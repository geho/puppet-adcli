# adcli

## Table of Contents

1. Table of Contents
2. [Description](#description)
3. [Setup - The basics of getting started with adcli](#setup)
    * [What adcli affects](#what-adcli-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with adcli](#beginning-with-adcli)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

The adcli module allows managing Active Directory computer, user and group objects.
It also provides an ad fact about domain and ad-joined computer object info.

The module uses the adcli command line untility.
Parameters of the command line tool have corresponding parameters for classes
and resources in the adcli puppet module.

Get more information about adcli by reading the manpage:

`man adcli`

## Setup

### What adcli affects

* Package adcli
* objects in Active Directory (computers, users, groups, group membership)
* Dependencies:
    * puppetlabs/stdlib  (module adcli uses stdlib types for parameters)
    * puppet/openldap  (module adcli uses ldapsearch to check existence of ad user and group objects)
    * gem inifile  (module adcli uses inifile top parse adcli info output for fact ad)

### Setup Requirements

To be able to install gem inifile the clients running puppet agent need internet access
or an corresponding proxy setup.

Active Directory permissions:

* At least an Active directory account with permissions to join computers is required.
* The Active Directory account needs additional permissions for user and group management.

Encrypting ad account credentials:

* hiera using eyaml encryption

### Beginning with adcli

Best practise is to start with adcli is to configure defaults via hiera and then include adcli class.
This has the advantage that the clear text password for ad account can be encrypted using eyaml.
This would just join the server to Active Directory.

Hiera:

```yaml
adcli::domain: 'example.org'
adcli::domain_controller: 'dc.example.org'
adcli::login_user: 'adjoin'
adcli::password: 'ENC[PKCS7,...'
```

Puppet manifest:

```puppet
include adcli
```

Another possibility to start with adcli is to declare the adcli class.
At least the password should be eyaml encrypted!

Puppet manifest:

```puppet
class { 'adcli':
  domain            => 'example.org',
  domain_controller => 'dc.example.org',
  login_user        => 'adjoin',
  password          => lookup('adcli::password'),
}
```

## Usage

### Join the node to Active Directory

Define Active Directory parameters in hiera data:

```yaml
adcli::domain: 'example.org'
adcli::domain_controller: 'dc.example.org'
adcli::domain_basedn: 'dc=example,dc=org'
adcli::domain_computer_ou: 'ou=Servers,ou=Accounts,dc=example,dc=org'
adcli::login_user: 'adjoin'
adcli::password: 'ENC[PKCS7,...'
```

Include adcli class in manifest file:

```puppet
include adcli
```

### Manage user accounts in Active Directory

Define Active Directory and user parameters in hiera data:

```yaml
adcli::domain: 'example.org'
adcli::domain_controller: 'dc.example.org'
adcli::domain_basedn: 'dc=example,dc=org'
adcli::domain_computer_ou: 'ou=Servers,ou=Accounts,dc=example,dc=org'
adcli::domain_user_ou: 'ou=Users,ou=Accounts,dc=example,dc=org'
adcli::login_user: 'adjoin'
adcli::password: 'ENC[PKCS7,...'
adcli::users:
  'user1':
    ensure: 'present'
    user_name: 'user1'
    user_display_name: 'user1 display name'
    mail: "user1@%{lookup('adcli::domain')}"
    unix_home: '/home/user1'
    unix_uid: '1001'
    unix_gid: '1001'
    domain_dn: 'ou=Admins,ou=Accounts,dc=example,dc=org'
  'user2':
    ensure: 'created'
    user_name: 'user2'
    user_display_name: 'user2 display name'
    mail: "user2@%{lookup('adcli::domain')}"
    unix_home: '/home/user2'
    unix_uid: '1002'
    unix_gid: '1002'
  'user3':
    ensure: 'absent'
    user_name: 'user3'
    user_display_name: 'user3 display name'
    mail: "user3@%{lookup('adcli::domain')}"
    unix_home: '/home/user3'
    unix_uid: '1003'
    unix_gid: '1003'
  'user4':
    ensure: 'deleted'
    user_name: 'user4'
    user_display_name: 'user4 display name'
    mail: "user4@%{lookup('adcli::domain')}"
    unix_home: '/home/user4'
    unix_uid: '1004'
    unix_gid: '1004'
```

Include adcli class in manifest file:

```puppet
include adcli
```

### Manage group objects in Active Directory

Define Active Directory and group parameters in hiera data:

```yaml
adcli::domain: 'example.org'
adcli::domain_controller: 'dc.example.org'
adcli::domain_basedn: 'dc=example,dc=org'
adcli::domain_computer_ou: 'ou=Servers,ou=Accounts,dc=example,dc=org'
adcli::domain_group_ou: 'ou=Groups,ou=Accounts,dc=example,dc=org'
adcli::login_user: 'adjoin'
adcli::password: 'ENC[PKCS7,...'
adcli::groups:
  'group1':
    group_name: 'group1'
    group_description: 'group1 description'
  'group2':
    group_name: 'group2'
    group_description: 'group2 description'
```

Include adcli class in manifest file:

```puppet
include adcli
```

### Manage group members in Active Directory

Define Active Directory user, group and member parameters in hiera data:

```yaml
adcli::domain: 'example.org'
adcli::domain_controller: 'dc.example.org'
adcli::domain_basedn: 'dc=example,dc=org'
adcli::domain_computer_ou: 'ou=Servers,ou=Accounts,dc=example,dc=org'
adcli::domain_user_ou: 'ou=Users,ou=Accounts,dc=example,dc=org'
adcli::domain_group_ou: 'ou=Groups,ou=Accounts,dc=example,dc=org'
adcli::login_user: 'adjoin'
adcli::password: 'ENC[PKCS7,...'
adcli::users:
  'user1':
    ensure: 'present'
    user_name: 'user1'
    user_display_name: 'user1 display name'
    mail: "user1@%{lookup('adcli::domain')}"
    unix_home: '/home/user1'
    unix_uid: '1001'
    unix_gid: '1001'
    domain_dn: 'ou=Admins,ou=Accounts,dc=example,dc=org'
  'user2':
    ensure: 'created'
    user_name: 'user2'
    user_display_name: 'user2 display name'
    mail: "user2@%{lookup('adcli::domain')}"
    unix_home: '/home/user2'
    unix_uid: '1002'
    unix_gid: '1002'
  'user3':
    ensure: 'absent'
    user_name: 'user3'
    user_display_name: 'user3 display name'
    mail: "user3@%{lookup('adcli::domain')}"
    unix_home: '/home/user3'
    unix_uid: '1003'
    unix_gid: '1003'
  'user4':
    ensure: 'deleted'
    user_name: 'user4'
    user_display_name: 'user4 display name'
    mail: "user4@%{lookup('adcli::domain')}"
    unix_home: '/home/user4'
    unix_uid: '1004'
    unix_gid: '1004'
adcli::groups:
  'group1':
    group_name: 'group1'
    group_description: 'group1 description'
  'group2':
    group_name: 'group2'
    group_description: 'group2 description'
adcli::members:
  'group1':
    group_name: 'group1'
    members:
      'user1': 'present'
      'user2': 'absent'
  'group2':
    group_name: 'group2'
    members:
      'user1': 'present'
      'user2': 'absent'
```

Include adcli class in manifest file:

```puppet
include adcli
```

## Limitations

It is not possible to set an initial password for user objects.
So the user accounts are disabled when created.

## Development

The adcli module has been developed using pdk.

## License
This codebase is licensed under the Apache2.0 licensing.
