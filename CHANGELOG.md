# Changelog

All notable changes to this project will be documented in this file.

## Release 0.1.0

**Features**

- initial release
- adcli package management
- ad computer object management
- ad user object management
- ad group object management
- ad group members management

**Bugfixes**

- n/a

**Known Issues**

- no initial user paswords, created accounts are disabled

## 0.1.1

### Changed

- Remove domain_controllers from facter (long list in huge environments might be > 4096 bytes)

