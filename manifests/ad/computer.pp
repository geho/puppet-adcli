# @summary Ensures AD computer object actions preset-computer, join, update, reset-computer and delete-computer.
#
# Manage AD computer account
#
# @param ensure
#   Ensures ad computer object state.
#   Type: Enum['present', 'absent', 'preset', 'joined', 'updated', 'reset', 'deleted']
#   Default: 'joined'
#
# @param log_output
#   Enable or disable puppet logging output when calling the adcli command.
#   Important: Avoid enabling log_output. The output will contain the login users password in cleartext!
#   Type: Boolean
#   Default: false
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
# @param domain_dn
#   The full distinguished name of the OU in which to create the computer account. If not specified, then the computer account will be
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
#   Password of login_user account to authenticate with the domain.
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
# @example
#   include adcli
#   adcli::ad::computer { $facts['networking']['fqdn']: }
#
define adcli::ad::computer (
  #
  # computer object management
  #
  Enum['present', 'absent', 'preset', 'joined', 'updated', 'reset', 'deleted'] $ensure = $adcli::ad_computer_ensure,
  #
  # puppet log output control
  # 
  Boolean                           $log_output                          = $adcli::log_output,
  #
  # domain parameters
  #
  Optional[Stdlib::Fqdn]            $domain                              = $adcli::domain,
  Optional[Stdlib::Fqdn]            $domain_realm                        = $adcli::domain_realm,
  Optional[Stdlib::Fqdn]            $domain_controller                   = $adcli::domain_controller,
  Optional[String]                  $domain_dn                           = $adcli::domain_computer_ou,
  # account to access ad for adding, modifying or removing ad computer or user/group objects and attributes
  Optional[Enum['computer','user']] $login_type                          = $adcli::login_type,
  # auth variant 1: username + password (AD user with at least join permissions, at most including permissions for user and group
  #                                     management) 
  Optional[String]                  $login_user                          = $adcli::login_user,
  Optional[String]                  $password                            = $adcli::password,
  # auth variant 2: one time password of computer account
  Optional[String]                  $one_time_password                   = $adcli::one_time_password,
  # auth variant 3: kerberos cerdentials in ccache
  Optional[String]                  $login_ccache                        = $adcli::login_ccache,
  #
  # host parameters (preset-computer, join, update, reset-computer, delete-computer)
  #
  Optional[String]                  $computer_name                       = $adcli::computer_name,
  #Optional[String]                  $host_name                           = $adcli::host_name,
  Optional[Stdlib::Fqdn]            $host_fqdn                           = $adcli::host_fqdn,
  Optional[Stdlib::Absolutepath]    $host_keytab                         = $adcli::host_keytab,
  Optional[String]                  $os_name                             = $adcli::os_name,
  Optional[String]                  $os_version                          = $adcli::os_version,
  Optional[String]                  $os_service_pack                     = $adcli::os_service_pack,
  Optional[String]                  $description                         = $adcli::description,
  Optional[Boolean]                 $preset_user_principal               = $adcli::preset_user_principal,
  Optional[String]                  $user_principal                      = $adcli::user_principal,
  Array[String]                     $service_names                       = $adcli::service_names,
  Array[String]                     $service_principals                  = $adcli::service_principals,
  Array[String]                     $attributes                          = $adcli::attributes,
  Optional[Boolean]                 $trusted_for_delegation              = $adcli::trusted_for_delegation,
  Optional[Boolean]                 $dont_expire_password                = $adcli::dont_expire_password,
  Optional[Variant[String,Integer]] $computer_password_lifetime          = $adcli::computer_password_lifetime,
  Optional[Boolean]                 $account_disable                     = $adcli::account_disable,
  Optional[Boolean]                 $computer_account_as_root_k5identity = $adcli::computer_account_as_root_k5identity,
  #
  # samba integration
  #
  Optional[Boolean]                 $add_samba_data                      = $adcli::add_samba_data,
  Optional[Stdlib::Absolutepath]    $samba_data_tool                     = $adcli::samba_data_tool,
) {
  # The base class must be included first because it is used by parameter defaults
  if ! defined(Class['adcli']) {
    fail('You must include the adcli base class before using any adcli defined resources')
  }
  # parameter checks
  if $ensure == 'preset' {
    if $password and $password != '' {
      # ok - check passed
    } else {
      fail("You must specify password to ensure ${ensure}")
    }
  }
  elsif $ensure == 'present' or $ensure == 'joined' {
    if ($password and $password != '') or ($one_time_password and $one_time_password != '') or ($login_ccache and $login_ccache != '') {
      # ok - check passed
    } else {
      fail("You must specify either password or one_time_password or login_ccache to ensure ${ensure}")
    }
  } else {
    if ($password and $password != '') or ($login_ccache and $login_ccache != '') {
      # ok - check passed
    } else {
      fail("You must specify either password or login_ccache to ensure ${ensure}")
    }
  }
  #
  # domain parameters
  #
  $domain_args = adcli::domain_arguments($domain, $domain_realm, $domain_controller,
    undef, $domain_dn, undef, undef,
    $login_type, $login_user, $password, $login_ccache, $one_time_password,
    undef, $host_fqdn, undef, $computer_name,
    undef, undef, undef, undef
  )
  #notify { 'profile::os::linux::adcli::DEBUG_domain_arguments':
  #  message  => "domain_arguments=${domain_args}",
  #  withpath => true,
  #}
  #
  # host parameters (preset-computer, join, update, reset-computer, delete-computer)
  #
  $computer_args = adcli::computer_arguments($os_name, $os_version, $os_service_pack, $description, $preset_user_principal, $user_principal,
    $service_names, $service_principals, $attributes, $trusted_for_delegation, $dont_expire_password, $computer_password_lifetime,
    $account_disable, $add_samba_data, $samba_data_tool
  )
  #notify { 'profile::os::linux::adcli::DEBUG_computer_arguments':
  #  message  => "computer_arguments=${computer_args}",
  #  withpath => true,
  #}
  #
  # exec parameters
  #
  $command_condition = "adcli testjoin ${domain_args['domain_option']} ${domain_args['domain_controller_option']} ${domain_args['host_keytab_option']}" # lint:ignore:140chars
  $command_join = join([
      $domain_args['stdout_password'],
      'adcli join',
      $domain_args['stdin_password'],
      $domain_args['domain_option'],
      $domain_args['domain_realm_option'],
      $domain_args['domain_controller_option'],
      $domain_args['domain_computer_ou_option'],
      $domain_args['login_type_option'],
      $domain_args['login_user_option'],
      $domain_args['login_ccache_option'],
      $domain_args['one_time_password_option'],
      $domain_args['host_fqdn_option'],
      $domain_args['host_keytab_option'],
      $domain_args['computer_name_option'],
      $computer_args['os_name_option'],
      $computer_args['os_version_option'],
      $computer_args['os_service_pack_option'],
      $computer_args['description_option'],
      $computer_args['user_principal_option'],
      $computer_args['service_names_option'],
      $computer_args['service_principals_option'],
      $computer_args['attributes_option'],
      $computer_args['trusted_for_delegation_option'],
      $computer_args['dont_expire_password_option'],
      # computer_password_lifetime_option
      # account_disable_option
      $computer_args['add_samba_data_option'],
      $computer_args['samba_data_tool_option'],
  ], ' ')
  if $ensure == 'preset' {
    $command = join([
        $domain_args['stdout_password'],
        'adcli preset-computer',
        $domain_args['stdin_password'],
        $domain_args['domain_option'],
        $domain_args['domain_realm_option'],
        $domain_args['domain_controller_option'],
        $domain_args['domain_computer_ou_option'],
        # login_type
        $domain_args['login_user_option'],
        # login_ccache
        $domain_args['one_time_password_option'],
        $domain_args['host_keytab_option'],
        # computer_name
        $computer_args['os_name_option'],
        $computer_args['os_version_option'],
        $computer_args['os_service_pack_option'],
        # description_option
        # ...
        $computer_args['service_names_option'],
        $computer_args['preset_user_principal_option'],
        $domain_args['host_fqdn_param'],
    ], ' ')
    $condition = 'unless'
  }
  elsif $ensure == 'present' or $ensure == 'joined' {
    $command = $command_join
    $condition = 'unless'
  }
  elsif $ensure == 'updated' {
    $command = join([
        $domain_args['stdout_password'],
        'adcli update',
        $domain_args['stdin_password'],
        $domain_args['domain_option'],
        $domain_args['domain_realm_option'],
        $domain_args['domain_controller_option'],
        $domain_args['domain_computer_ou_option'],
        $domain_args['login_type_option'],
        $domain_args['login_user_option'],
        $domain_args['login_ccache_option'],
        $domain_args['host_fqdn_option'],
        $domain_args['host_keytab_option'],
        $domain_args['computer_name_option'],
        $computer_args['os_name_option'],
        $computer_args['os_version_option'],
        $computer_args['os_service_pack_option'],
        $computer_args['description_option'],
        $computer_args['user_principal_option'],
        $computer_args['service_names_option'],
        $computer_args['service_principals_option'],
        $computer_args['attributes_option'],
        $computer_args['dont_expire_password_option'],
        $computer_args['computer_password_lifetime_option'],
        $computer_args['account_disable_option'],
        $computer_args['trusted_for_delegation_option'],
        $computer_args['add_samba_data_option'],
        $computer_args['samba_data_tool_option'],
    ], ' ')
    $condition = 'onlyif'
  }
  elsif $ensure == 'reset' {
    $command = join([
        $domain_args['stdout_password'],
        'adcli reset',
        $domain_args['stdin_password'],
        $domain_args['domain_option'],
        $domain_args['domain_realm_option'],
        $domain_args['domain_controller_option'],
        $domain_args['domain_computer_ou_option'],
        $domain_args['login_type_option'],
        $domain_args['login_user_option'],
        $domain_args['login_ccache_option'],
        $domain_args['one_time_password_option'],
        $domain_args['host_fqdn_param'],
    ], ' ')
    $condition = 'onlyif'
  }
  elsif $ensure == 'absent' or $ensure == 'deleted' {
    $command = join([
        $domain_args['stdout_password'],
        'adcli delete-computer',
        $domain_args['stdin_password'],
        $domain_args['domain_option'],
        $domain_args['login_user_option'],
        $domain_args['host_fqdn_param'],
    ], ' ')
    $condition = 'onlyif'
  }
  #
  # execute adcli command
  #
  #notify { 'profile::os::linux::adcli::DEBUG_exec':
  #  message  => "command_join=${command_join}\ncommand=${command}\ncommand_condition=${command_condition}",
  #  withpath => true,
  #}
  if $ensure == 'updated' {
    # ensure computer account is joined before ensure it's updated
    exec { "adcli::ad::computer:${domain_args['host_fqdn']}_joined":
      path      => '/usr/bin:/bin:/usr/sbin:/sbin',
      command   => $command_join,
      unless    => $command_condition,
      logoutput => $log_output,
      require   => Class['adcli::install'],
    }
  }
  if $condition == 'unless' {
    exec { "adcli::ad::computer:${domain_args['host_fqdn']}_${ensure}_unless":
      path      => '/usr/bin:/bin:/usr/sbin:/sbin',
      command   => $command,
      unless    => $command_condition,
      logoutput => $log_output,
      require   => Class['adcli::install'],
    }
  } else {
    exec { "adcli::ad::computer:${domain_args['host_fqdn']}_${ensure}_onlyif":
      path      => '/usr/bin:/bin:/usr/sbin:/sbin',
      command   => $command,
      onlyif    => $command_condition,
      logoutput => $log_output,
      require   => Class['adcli::install'],
    }
  }
  if $computer_account_as_root_k5identity == true {
    file { '/root/.k5identity':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
      content => "${domain_args['computer_account']}@${domain_args['domain_realm']}",
    }
  }
}
