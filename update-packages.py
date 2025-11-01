#!/usr/bin/env python3
"""
Script to update Chocolatey packages from JSON manifest files.

This script reads JSON manifest files from the 'bucket' directory and updates
the corresponding .nuspec files and chocolateyinstall.ps1 files with the
latest version, URLs, and checksums.
"""

import json
import os
import re
from pathlib import Path
from typing import Dict, Any, Optional

def load_manifest(manifest_path: Path) -> Dict[str, Any]:
    """Load and parse a JSON manifest file."""
    with open(manifest_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def get_tool_name_from_manifest(manifest_file: str) -> str:
    """Extract tool name from manifest filename."""
    return manifest_file.replace('.json', '')

def update_nuspec_file(nuspec_path: Path, version: str) -> bool:
    """Update the version in a .nuspec file."""
    if not nuspec_path.exists():
        print(f"Warning: {nuspec_path} does not exist")
        return False
    
    try:
        content = nuspec_path.read_text(encoding='utf-8')
        
        # Update version using regex
        version_pattern = r'<version>([^<]+)</version>'
        if re.search(version_pattern, content):
            updated_content = re.sub(version_pattern, f'<version>{version}</version>', content)
            nuspec_path.write_text(updated_content, encoding='utf-8')
            print(f"✅ Updated {nuspec_path.name} version to {version}")
            return True
        else:
            print(f"Warning: Version tag not found in {nuspec_path}")
            return False
    except Exception as e:
        print(f"Error updating {nuspec_path}: {e}")
        return False

def update_chocolatey_install(install_path: Path, manifest: Dict[str, Any]) -> bool:
    """Update chocolateyinstall.ps1 with URLs and checksums from manifest."""
    if not install_path.exists():
        print(f"Warning: {install_path} does not exist")
        return False
    
    try:
        content = install_path.read_text(encoding='utf-8')
        architecture = manifest.get('architecture', {})
        
        # Extract URLs and checksums
        url_64 = None
        url_arm64 = None
        checksum_64 = None
        checksum_arm64 = None
        
        if '64bit' in architecture:
            arch_64 = architecture['64bit']
            if isinstance(arch_64.get('url'), list) and arch_64['url']:
                url_64 = arch_64['url'][0]
            elif isinstance(arch_64.get('url'), str):
                url_64 = arch_64['url']
            
            if isinstance(arch_64.get('hash'), list) and arch_64['hash']:
                checksum_64 = arch_64['hash'][0]
            elif isinstance(arch_64.get('hash'), str):
                checksum_64 = arch_64['hash']
        
        if 'arm64' in architecture:
            arch_arm64 = architecture['arm64']
            if isinstance(arch_arm64.get('url'), list) and arch_arm64['url']:
                url_arm64 = arch_arm64['url'][0]
            elif isinstance(arch_arm64.get('url'), str):
                url_arm64 = arch_arm64['url']
            
            if isinstance(arch_arm64.get('hash'), list) and arch_arm64['hash']:
                checksum_arm64 = arch_arm64['hash'][0]
            elif isinstance(arch_arm64.get('hash'), str):
                checksum_arm64 = arch_arm64['hash']
        
        # Get tool name for conditional processing
        tool_name = install_path.parent.name
        
        # Clean URLs by removing chocolatey filename fragments for specific tools
        if tool_name in ['pact', 'pact-broker-client']:
            if url_64 and '#/' in url_64:
                url_64 = url_64.split('#/')[0]
            if url_arm64 and '#/' in url_arm64:
                url_arm64 = url_arm64.split('#/')[0]
        
        # Check if this is pact-legacy format (uses hashtable instead of separate variables)
        if tool_name == 'pact-legacy' and url_64 and checksum_64:
            # Update pact-legacy format: url and checksum inside hashtable
            # Use more specific regex patterns to match only the property lines
            content = re.sub(
                r"^(\s+url\s+=\s+')[^']*'",
                f"  url           = '{url_64}'",
                content,
                count=1,
                flags=re.MULTILINE
            )
            content = re.sub(
                r"^(\s+checksum\s+=\s+')[^']*'",
                f"  checksum      = '{checksum_64}'",
                content,
                count=1,
                flags=re.MULTILINE
            )
        else:
            # Standard format: separate variables
            # Update URLs
            if url_64:
                content = re.sub(r"\$url64 = '[^']*'", f"$url64 = '{url_64}'", content, count=1)
            if url_arm64:
                content = re.sub(r"\$urlARM64 = '[^']*'", f"$urlARM64 = '{url_arm64}'", content, count=1)
            
            # Update checksums
            if checksum_64:
                content = re.sub(r"\$checksum64 = '[^']*'", f"$checksum64 = '{checksum_64}'", content, count=1)
            if checksum_arm64:
                content = re.sub(r"\$checksumARM64 = '[^']*'", f"$checksumARM64 = '{checksum_arm64}'", content, count=1)
        
        install_path.write_text(content, encoding='utf-8')
        print(f"✅ Updated {install_path.name} with new URLs and checksums")
        return True
        
    except Exception as e:
        print(f"Error updating {install_path}: {e}")
        return False

def process_tool(bucket_dir: Path, tool_name: str, manifest: Dict[str, Any]) -> None:
    """Process a single tool's manifest and update its files."""
    print(f"\n🔧 Processing {tool_name}...")
    
    version = manifest.get('version')
    if not version:
        print(f"❌ No version found in manifest for {tool_name}")
        return
    
    # Update .nuspec file
    nuspec_path = bucket_dir.parent / f"{tool_name}.nuspec"
    update_nuspec_file(nuspec_path, version)
    
    # Update chocolateyinstall.ps1
    install_path = bucket_dir.parent / "tools" / tool_name / "chocolateyinstall.ps1"
    update_chocolatey_install(install_path, manifest)

def main():
    """Main function to process all manifest files."""
    script_dir = Path(__file__).parent
    bucket_dir = script_dir / "bucket"
    
    if not bucket_dir.exists():
        print(f"❌ Bucket directory not found: {bucket_dir}")
        return 1
    
    print("🚀 Starting Chocolatey package updates from manifest files...")
    
    # Get all JSON files in bucket directory
    manifest_files = list(bucket_dir.glob("*.json"))
    
    if not manifest_files:
        print("❌ No JSON manifest files found in bucket directory")
        return 1
    
    success_count = 0
    total_count = len(manifest_files)
    
    for manifest_file in manifest_files:
        try:
            tool_name = get_tool_name_from_manifest(manifest_file.name)
            manifest = load_manifest(manifest_file)
            
            process_tool(bucket_dir, tool_name, manifest)
            success_count += 1
            
        except Exception as e:
            print(f"❌ Error processing {manifest_file.name}: {e}")
    
    print(f"\n📊 Summary: {success_count}/{total_count} tools processed successfully")
    
    if success_count == total_count:
        print("🎉 All packages updated successfully!")
        return 0
    else:
        print("⚠️  Some packages had issues. Please check the output above.")
        return 1

if __name__ == "__main__":
    exit(main())