# Bump Version

## Usage

```yaml
name: Bump Version

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
        uses: opspresso/action-builder@master
```
