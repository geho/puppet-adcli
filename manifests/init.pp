# @summary Installs adcli and ensures AD actions for computers, users and groups
#
# Manage AD objects via adcli
#
# @param manage_package
#   Enable or disable package management.
#   Type: Boolean
#   Default: true
# @param manage_ad_computer
#   Enable or disable AD computer object management.
#   Type: Boolean
#   Default: true
# @param manage_ad_users
#   Enable or disable AD user objects management.
#   Type: Boolean
#   Default: true
# @param manage_ad_groups
#   Enable or disable AD group objects management.
#   Type: Boolean
#   Default: true
# @param manage_ad_members
#   Enable or disable AD group member management.
#   Type: Boolean
#   Default: true
# @param manage_openldap_utils
#   Enable or disable openladp utils package management.
#   Type: Boolean
#   Default: true
#
# @param log_output
#   Enable or disable puppet logging output when calling the adcli command.
#   Important: Avoid enabling log_output. The output will contain the login users password in cleartext!
#   Type: Boolean
#   Default: false
#
# @param package_ensure
#   Ensure package is set to defined state.
#   Type: Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest']
#   Default: 'installed'
# @param package_name
#   Specify the default package name.
#   Type: String
#   Default: 'adcli'
#
# @param ad_computer_ensure
#   Ensure ad computer object state.
#   Type: Enum['present', 'absent', 'preset', 'joined', 'updated', 'reset', 'deleted']
#   Default: 'joined'
#
# @param domain
#   The domain to connect to. If a domain is not specified, then the domain part of the local computer's host name is used.
#   Type: String
#   Default: undef
# @param domain_realm
#   Kerberos realm for the domain. If not specified, then the upper cased domain name is used.
#   Type: Optional[Stdlib::Fqdn]
#   Default: undef
# @param domain_controller
#   Connect to a specific domain controller. If not specified, then an appropriate domain controller is automatically discovered.
#   Type: Optional[Stdlib::Fqdn]
#   Default: undef
# @param domain_basedn
#   The full distinguished name of the domain/ldap base. If not specified, then the basedn is constructed from the domain name.
#   Type: Optional[String]
#   Default: undef
# @param domain_computer_ou
#   The full distinguished name of the OU in which to create the computer account. If not specified, then the computer account will be
#   created in a default location.
#   Type: Optional[String]
#   Default: undef
# @param domain_user_ou
#   The full distinguished name of the OU in which to create the user account. If not specified, then the user account will be
#   created in a default location.
#   Type: Optional[String]
#   Default: undef
# @param domain_group_ou
#   The full distinguished name of the OU in which to create the group object. If not specified, then the group object will be
#   created in a default location.
#   Type: Optional[String]
#   Default: undef
#
# @param login_type
#   Specify the type of authentication that will be performed before creating the machine account in the domain. If set to 'computer',
#   then the computer must already have a preset account in the domain. If not specified and none of the other login_xxx arguments have
#   been specified, then will try both 'computer' and 'user' authentication.
#   Type: Optional[Enum['computer','user']]
#   Default: undef
# @param login_user
#   Use the specified user account to authenticate with the domain. If not specified, then the name 'Administrator' will be used.
#   Type: Optional[String]
#   Default: undef
# @param password
#   Password of login_user account to authenticate with the domain..
#   Note: This can be set in hiera using eyaml/pkcs7 for encryption.
#   Type: Optional[String]
#   Default: undef
# @param one_time_password
#   Specify a one time password for a preset computer account. This is equivalent to using login_type=computer and providing a password
#   as input.
#   Type: Optional[String]
#   Default: undef
# @param login_ccache
#   Use the specified Kerberos credential cache to authenticate with the domain. If no credential cache is specified, the default Kerberos
#   credential cache will be used. Credential caches of type FILE can be given with the path to the file. For other credential cache types,
#   e.g. DIR, KEYRING or KCM, the type must be specified explicitly together with a suitable identifier.
#   Type: Optional[String]
#   Default: undef
#
# @param computer_name
#   The short non-dotted name of the computer account that will be created in the domain. If not specified, then the first portion of the
#   host_fqdn is used.
#   Type: Optional[String]
#   Default: undef
# @param host_fqdn
#   Override the local machine's fully qualified domain name. If not specified, the local machine's hostname will be retrieved via
#   gethostname(). If gethostname() only returns a short name getaddrinfo() with the AI_CANONNAME hint is called to expand the name to a
#   fully qualified domain name.
#   Type: Optional[Stdlib::Fqdn]
#   Default: undef
# @param host_keytab
#   Specify the path to the host keytab where host credentials will be written after a successful join operation. If not specified, the
#   default location will be used, usually /etc/krb5.keytab.
#   Type: Optional[Stdlib::Absolutepath]
#   Default: undef
# @param os_name
#   Set the operating system name on the computer account. The default depends on where adcli was built, but is usually something like
#   'linux-gnu'.
#   Type: Optional[String]
#   Default: undef
# @param os_version
#   Set the operating system version on the computer account. Not set by default.
#   Type: Optional[String]
#   Default: undef
# @param os_service_pack
#   Set the operating system service pack on the computer account. Not set by default.
#   Type: Optional[String]
#   Default: undef
# @param description
#   Set the description attribute on the computer account. Not set by default.
#   Type: Optional[String]
#   Default: undef
# @param preset_user_principal
#   Set the userPrincipalName field of the computer account in the form of host/host.example.com@REALM.
#   Type: Optional[Boolean]
#   Default: undef
# @param user_principal
#   Set the userPrincipalName field of the computer account to this Kerberos principal. If you omit the value for this option, then a
#   principal will be set in the form of host/host.example.com@REALM
#   Type: Optional[String]
#   Default: undef
# @param service_names
#   Additional service names for Kerberos principals to be created on the computer account.
#   Type: Array[String]
#   Default: []
# @param service_principals
#   Add service principal names. In contrast to the service_names the hostname part can be specified as well in case the service should be
#   accessible with a different host name as well.
#   Type: Array[String]
#   Default: []
# @param attributes
#   Add the LDAP attribute names with the given values to the new LDAP host object. Multi-value attributes are currently not supported.
#   Type: Array[String]
#   Default: []
# @param trusted_for_delegation
#   Set or unset the TRUSTED_FOR_DELEGATION flag in the userAccountControl attribute to allow or not allow that Kerberos tickets can be
#   forwarded to the host.
# @param dont_expire_password
#   Set or unset the DONT_EXPIRE_PASSWORD flag in the userAccountControl attribute to indicate if the machine account password should
#   expire or not. By default adcli will set this flag while joining the domain which corresponds to the default behavior of Windows
#   clients.
#   Type: Optional[Boolean]
#   Default: undef
# @param computer_password_lifetime
#   Only update the password of the computer account if it is older than the lifetime given in days. By default the password is updated if
#   it is older than 30 days.
#   Type: Optional[Variant[String,Integer]]
#   Default: undef
# @param account_disable
#   Set or unset the ACCOUNTDISABLE flag in the userAccountControl attribute to disable or enable the computer account.
#   Type: Optional[Boolean]
#   Default: undef
# @param computer_account_as_root_k5identity
#   Create file /root/.k5identity with computers ad account name 'HOSTNAME$@DOMAINREALM' as content.
#   Type: Optional[Boolean]
#   Default: undef
# @param add_samba_data
#   After a successful join add the domain SID and the machine account password to the Samba specific databases
#   by calling Samba's net utility.
#   Type: Optional[Boolean]
#   Default: undef
# @param samba_data_tool
#   After a successful join add the domain SID and the machine account password to the Samba specific databases by calling Samba's net
#   utility.
#   Type: Optional[Stdlib::Absolutepath]
#   Default: undef
#
# @param ad_user_ensure
#   Ensure ad user object state.
#   Type: Enum['present', 'absent', 'created', 'deleted']
#   Default: 'created'
# @param user_name
#   Specify username for the account to be created.
#   Type: Optional[String]
#   default: undef
# @param user_display_name
#   Set the displayName attribute of the new created user account.
#   Type: Optional[String]
#   Default: undef
# @param mail
#   Set the mail attribute of the new created user account. This attribute may be specified multiple times. (TODO)
#   Type: Optional[String]
#   Default: TODO
# @param unix_home
#   Set the unixHomeDirectory attribute of the new created user account, which should be an absolute path to the user's home directory.
#   Default: undef
# @param unix_uid
#   Set the uidNumber attribute of the new created user account, which should be the user's numeric primary user id.
#   Type: Optional[String]
#   Default: undef
# @param unix_gid
#   Set the gidNumber attribute of the new created user account, which should be the user's numeric primary group id.
#   Type: Optional[String]
#   Default: undef
# @param unix_shell
#   Set the loginShell attribute of the new created user account, which should be a path to a valid shell.
#   Default: undef
# @param nis_domain
#   Set the msSFU30NisDomain attribute of the new created user account, which should be the user's NIS domain is the NIS/YP service of
#   Active Directory's Services for Unix (SFU) are used.
#   This is needed to let the 'UNIX attributes' tab of older Active Directory versions show the set UNIX specific attributes.
#   If not specified adcli will try to determine the NIS domain automatically if needed.
#   Type: Optional[String]
#   Default: undef
#
# @param users
#   Hash of user accounts to be managed.
#   Type: Hash
#   Default: {}
#
# @param ad_group_ensure
#   Ensure ad group object state.
#   Type: Enum['present', 'absent', 'created', 'deleted']
#   Default: 'created'
# @param group_name
#   Specify group name for the group to be created.
#   Type: Optional[String]
#   default: undef
# @param group_description
#   Set the description attribute of the new created group.
#   Type: Optional[String]
#   Default: undef
#
# @param groups
#   Hash of groups to be managed.
#   Type: Hash
#   Default: {}
#
# @param members
#   Hash of group members to be managed.
#   Type: Hash
#   Default: {}
#
# @param ldap_auth_type
#   Select type of ldap authentication for testing objects and attributes in AD via ldapsearch.
#   Type: Optional[Enum['insecure', 'tls', 'gss_spnego', 'gssapi']]
#   Default: 'gssapi'
# @param ldaps_cacert_path
#   Specify CA certificates file path for ldap authentication.
#   Type: Optional[Stdlib::Absolutepath]
#   Default: undef
# @param ldap_binddn
#   Specify AD user account to be used for ldap authentication.
#   Type: Optional[String]
#   Default: undef
# @param ldap_bindpw
#   Specify AD user password to be used for ldap authentication. Only required for authentication types 'insecure' or 'tls'.
#   Type: Optional[String]
#   Default: undef
#
# @param manage_gem_inifile
#   Enable or disable inifile gem management (inifile is required to parse adcli output for facts).
#   Type: Boolean
#   Default: true
# @param ensure_gem_inifile
#   Ensure gem is set to defined state.
#   Type: Enum['present','absent','installed','purged']
#   Default: 'installed'
# @param package_name_gem_inifile
#   Specify the name of the gem package.
#   Type: String
#   Default: 'inifile'
# @param provider_gem_inifile
#   Specify the package provider of the gem package.
#   Type: String
#   Default: 'puppet_gem'
# @param source_gem_inifile
#   Specify an alternative source for the gem package.
#   Type: Optional[String]
#   Default: undef
# @param install_options_gem_inifile
#   Specify package install options.
#   Type: Array[String]
#   Default: ['--no-document']
#
# @example
#   include adcli
#
class adcli (
  #
  # required parameters ###################################################################################################################
  #
  # management scope
  #
  Boolean                           $manage_package,
  Boolean                           $manage_ad_computer,
  Boolean                           $manage_ad_users,
  Boolean                           $manage_ad_groups,
  Boolean                           $manage_ad_members,
  Boolean                           $manage_openldap_utils,
  #
  # puppet log output control
  # 
  Boolean                           $log_output,
  #
  # install / package management
  #
  Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest'] $package_ensure,
  String                            $package_name,
  #
  # computer object management
  #
  Enum['present', 'absent', 'preset', 'joined', 'updated', 'deleted'] $ad_computer_ensure,
  #
  # host parameters (preset-computer, join, update, reset-computer, delete-computer)
  #
  Array[String]                     $service_names,
  Array[String]                     $service_principals,
  Array[String]                     $attributes,
  #
  # user object management
  #
  Enum['present', 'absent', 'created', 'deleted'] $ad_user_ensure,
  #
  # user parameters (create-user, passwd-user, delete-user)
  #
  # Array[String]                     $user_service_names,
  Hash                              $users,
  #
  # group object management
  #
  Enum['present', 'absent', 'created', 'deleted'] $ad_group_ensure,
  #
  # group parameters (create-group, delete-group)
  #
  Hash                              $groups,
  #
  # group member parameters (add-member, remove-member) incl. management directives in hash
  #
  Hash                              $members,
  #
  # internal dependencies
  #
  Boolean                           $manage_gem_inifile,
  Enum['present','absent','installed','purged'] $ensure_gem_inifile,
  String                            $package_name_gem_inifile,
  String                            $provider_gem_inifile,
  Array[String]                     $install_options_gem_inifile,
  #
  # optional parameters ###################################################################################################################
  #
  # domain parameters
  #
  Optional[Stdlib::Fqdn]            $domain,
  Optional[Stdlib::Fqdn]            $domain_realm,
  Optional[Stdlib::Fqdn]            $domain_controller,
  Optional[String]                  $domain_basedn,
  Optional[String]                  $domain_computer_ou,
  Optional[String]                  $domain_user_ou,
  Optional[String]                  $domain_group_ou,
  # account to access ad for adding, modifying or removing ad computer or user/group objects and attributes
  Optional[Enum['computer','user']] $login_type,
  # auth variant 1: username + password (AD user with at least join permissions, at most including permissions for user and group
  #                                     management) 
  Optional[String]                  $login_user,
  Optional[String]                  $password,
  # auth variant 2: one time password of computer account
  Optional[String]                  $one_time_password,
  # auth variant 3: kerberos cerdentials in ccache
  Optional[String]                  $login_ccache,
  #
  # host parameters (preset-computer, join, update, reset-computer, delete-computer)
  #
  Optional[String]                  $computer_name,
  #Optional[String]                  $host_name,
  Optional[Stdlib::Fqdn]            $host_fqdn,
  Optional[Stdlib::Absolutepath]    $host_keytab,
  Optional[String]                  $os_name,
  Optional[String]                  $os_version,
  Optional[String]                  $os_service_pack,
  Optional[String]                  $description,
  Optional[Boolean]                 $preset_user_principal,
  Optional[String]                  $user_principal,
  Optional[Boolean]                 $trusted_for_delegation,
  Optional[Boolean]                 $dont_expire_password,
  Optional[Variant[String,Integer]] $computer_password_lifetime,
  Optional[Boolean]                 $account_disable,
  Optional[Boolean]                 $computer_account_as_root_k5identity,
  #
  # samba integration
  #
  Optional[Boolean]                 $add_samba_data,
  Optional[Stdlib::Absolutepath]    $samba_data_tool,
  #
  # user parameters (create-user, passwd-user, delete-user)
  #
  Optional[String]                  $user_name,
  Optional[String]                  $user_display_name,
  Optional[String]                  $mail,
  Optional[Stdlib::Absolutepath]    $unix_home,
  Optional[String]                  $unix_uid,
  Optional[String]                  $unix_gid,
  Optional[Stdlib::Absolutepath]    $unix_shell,
  Optional[String]                  $nis_domain,
  #
  # group parameters (create-group, delete-group)
  #
  Optional[String]                  $group_name,
  Optional[String]                  $group_description,
  #
  # ldap client parameters
  #
  Optional[Enum['insecure', 'tls', 'gss_spnego', 'gssapi']] $ldap_auth_type,
  Optional[Stdlib::Absolutepath]    $ldaps_cacert_path,
  Optional[String]                  $ldap_binddn,
  Optional[String]                  $ldap_bindpw,
  #
  # internal dependencies
  #
  Optional[String]                  $source_gem_inifile,
) {
  contain adcli::install
  if $manage_ad_computer {
    adcli::ad::computer { 'adcli::ad::computer': }
  }
  if $manage_ad_users {
    $users.each |String $username, Hash $userhash| {
      adcli::ad::user { $username:
        * => $userhash,
      }
    }
  }
  if $manage_ad_groups {
    $groups.each |String $groupname, Hash $grouphash| {
      adcli::ad::group { $groupname:
        * => $grouphash,
      }
    }
  }
  if $manage_ad_members {
    $members.each |String $memberskey, Hash $membershash| {
      adcli::ad::members { $memberskey:
        * => $membershash,
      }
    }
  }
}
