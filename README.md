# System Property Debugging Tool

A reference implementation for modifying Android system properties during the `post-fs-data` boot stage. This tool demonstrates how to interact with the Android property system using `resetprop`.

## Overview

This script is designed for developers and researchers to test system behavior when hardware identifiers are masked or modified. It specifically targets property keys such as `ro.serialno` and `persist.sys.serialno`.

## Features

- **Automated Property Injection**: Modifies both read-only (`ro.*`) and persistent (`persist.*`) properties.
- **Persistence Management**: Handles the deletion of cached persistent properties to ensure new values take effect.
- **Boot-time Execution**: Designed to run during the `post-fs-data` trigger, ensuring properties are set before most system services start.
- **Logging**: Provides detailed execution logs for debugging.

## Usage

1. Place the script in a directory compatible with your system's boot-time execution environment (e.g., a Magisk module directory).
2. (Optional) Create a `serial.txt` file in the same directory containing the desired identifier value.
3. The script will automatically generate a random value if `serial.txt` is missing.

## Disclaimer

**IMPORTANT: FOR RESEARCH AND EDUCATIONAL PURPOSES ONLY.**

This tool is provided "as is" without warranty of any kind. The authors are not responsible for:
- Any damage to your device.
- Any violation of Terms of Service of third-party applications.
- Any illegal or unethical use of this tool.

Users must ensure compliance with all local laws and regulations. Modifying system identifiers may have legal implications depending on your jurisdiction and intent.

## License

MIT License
