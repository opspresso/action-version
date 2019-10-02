# Version Bump

[![GitHub Actions status](https://github.com/opspresso/action-version/workflows/Build-Push/badge.svg)](https://github.com/opspresso/action-version/actions)
[![GitHub Releases](https://img.shields.io/github/release/opspresso/action-version.svg)](https://github.com/opspresso/action-version/releases)

## Usage

```yaml
name: Version Bump

on: push

jobs:
  builder:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@master
        with:
          fetch-depth: 1

      - name: Bump Version
        uses: opspresso/action-version@master
```
