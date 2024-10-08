# @summary Ensures AD group member actions add-member and remove-member.
#
# Manage AD group membership
#
# @param group_name
#   Specify name of the group.
#   Type: String
# @param members
#   Specify hash of group members.
#   Type: Hash
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
# @param domain_basedn
#   The full distinguished name of the domain/ldap base. If not specified, then the basedn is constructed from the domain name.
#   Type: Optional[String]
#   Default: undef
# @param domain_user_ou
#   The full distinguished name of the OU where to search the user account. If not specified, then the user account will be
#   searched from the basedn.
#   Type: Optional[String]
#   Default: undef
# @param domain_group_ou
#   The full distinguished name of the OU where to search the group object. If not specified, then the group object will be
#   searched from the basedn.
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
#   Specify the path to the host keytab where host credentials were written after a successful join operation. If not specified, the
#   default location will be used, usually /etc/krb5.keytab.
#   Type: Optional[Stdlib::Absolutepath]
#   Default: undef
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
# @example
#   include adcli
#   adcli::ad::members { 'namevar':
#     group_name => 'group1',
#     members    => {
#       'user1' => 'present',
#       'user1' => 'absent',
#     },
#   }
#
define adcli::ad::members (
  #
  # group member parameters (add-member, remove-member)
  #
  String                             $group_name                = undef,
  Hash                               $members                   = {},
  #
  # puppet log output control
  # 
  Boolean                           $log_output                 = $adcli::log_output,
  #
  # domain parameters
  #
  Optional[Stdlib::Fqdn]            $domain                     = $adcli::domain,
  Optional[Stdlib::Fqdn]            $domain_realm               = $adcli::domain_realm,
  Optional[Stdlib::Fqdn]            $domain_controller          = $adcli::domain_controller,
  Optional[String]                  $domain_basedn              = $adcli::domain_basedn,
  Optional[String]                  $domain_user_ou             = $adcli::domain_user_ou,
  Optional[String]                  $domain_group_ou            = $adcli::domain_group_ou,
  # account to access ad for adding, modifying or removing ad computer or user/group objects and attributes
  Optional[Enum['computer','user']] $login_type                 = $adcli::login_type,
  # auth variant 1: username + password (AD user with at least join permissions, at most including permissions for user and group
  #                                     management) 
  Optional[String]                  $login_user                 = $adcli::login_user,
  Optional[String]                  $password                   = $adcli::password,
  # auth variant 3: kerberos cerdentials in ccache
  Optional[String]                  $login_ccache               = $adcli::login_ccache,
  #
  # use computers credentials for ldap lookups
  #
  Optional[String]                  $computer_name              = $adcli::computer_name,
  Optional[Stdlib::Fqdn]            $host_fqdn                  = $adcli::host_fqdn,
  Optional[Stdlib::Absolutepath]    $host_keytab                = $adcli::host_keytab,
  #
  # ldap client parameters
  #
  Optional[Enum['insecure', 'tls', 'gss_spnego', 'gssapi']] $ldap_auth_type = $adcli::ldap_auth_type,
  Optional[Stdlib::Absolutepath]    $ldaps_cacert_path          = $adcli::ldaps_cacert_path,
  Optional[String]                  $ldap_binddn                = $adcli::ldap_binddn,
  Optional[String]                  $ldap_bindpw                = $adcli::ldap_bindpw,
) {
  # The base class must be included first because it is used by parameter defaults
  if !defined(Class['adcli']) {
    fail('You must include the adcli base class before using any adcli defined resources')
  }
  # parameter checks
  if $group_name and $members != {} {
    # ok - check passed
    $param_group_name = "'${group_name}'"
  } else {
    fail('You must specify group_name and members')
  }
  if ($password and $password != '') or ($login_ccache and $login_ccache != '') {
    # ok - check passed
  } else {
    fail('You must specify either password or login_ccache to ensure members')
  }
  #
  # domain parameters
  #
  $domain_args = adcli::domain_arguments($domain, $domain_realm, $domain_controller,
    $domain_basedn, undef, $domain_user_ou, $domain_group_ou,
    $login_type, $login_user, $password, $login_ccache, undef,
    undef, $host_fqdn, undef, $computer_name,
    $ldap_auth_type, $ldap_binddn, $ldap_bindpw, $ldaps_cacert_path
  )
  #
  # ldap authentication
  #
  if $ldap_auth_type == 'insecure' {
    if $domain_controller and $domain_basedn and $ldap_binddn and $ldap_bindpw {
      $ldapsearch = "ldapsearch -LLL -x -H ldap://${domain_args['domain_controller']} -D '${domain_args['ldap_binddn']}' -w '${domain_args['ldap_bindpw']}' -s sub -b '${domain_args['domain_basedn']}'"
    } else {
      fail("You have selected selected auth_type 'insecure'. You must specify all parameters: domain_controller, domain_basedn, ldap_binddn and ldap_bindpw!") # lint:ignore:140chars
    }
  }
  elsif $ldap_auth_type == 'tls' {
    if $domain_controller and $domain_basedn and $ldap_binddn and $ldap_bindpw and $ldaps_cacert_path {
      $ldapsearch = "ldapsearch -LLL -x -H ldaps://${domain_args['domain_controller']} -D '${domain_args['ldap_binddn']}' -w '${domain_args['ldap_bindpw']}' -o 'TLS_CACERT=${domain_args['ldaps_cacert_path']}' -s sub -b '${domain_args['domain_basedn']}'" # lint:ignore:140chars
    } else {
      fail("You have selected auth_type 'tls'. You must specify all parameters: domain_controller, domain_basedn, ldap_binddn, ldap_bindpw and ldaps_cacert_path!") # lint:ignore:140chars
    }
  }
  elsif $ldap_auth_type == 'gss_spnego' {
    if $domain_controller and $domain_basedn {
      $ldapsearch = "ldapsearch -LLL -Y GSS-SPNEGO -H ldap://${domain_args['domain_controller']} -s sub -b '${domain_args['domain_basedn']}'"
    } else {
      fail("You have selected auth_type 'gss_spnego'. You must specify all parameters: domain_controller and domain_basedn!")
    }
  }
  elsif $ldap_auth_type == 'gssapi' {
    if $domain_controller and $domain_basedn {
      $ldapsearch = "ldapsearch -LLL -Y GSSAPI -H ldap://${domain_args['domain_controller']} -s sub -b '${domain_args['domain_basedn']}'"
    } else {
      fail("You have selected auth_type 'gssapi'. You must specify all parameters: domain_controller and domain_basedn!")
    }
  }
  #
  # exec parameters
  #
  $command_add = join([
      $domain_args['stdout_password'],
      'adcli add-member',
      $domain_args['stdin_password'],
      $domain_args['domain_option'],
      $domain_args['domain_realm_option'],
      $domain_args['domain_controller_option'],
      $domain_args['login_user_option'],
      $domain_args['login_ccache_option'],
      $param_group_name,
  ], ' ')
  $command_remove = join([
      $domain_args['stdout_password'],
      'adcli remove-member',
      $domain_args['stdin_password'],
      $domain_args['domain_option'],
      $domain_args['domain_realm_option'],
      $domain_args['domain_controller_option'],
      $domain_args['login_user_option'],
      $domain_args['login_ccache_option'],
      $param_group_name,
  ], ' ')
  $command_condition_group = "${ldapsearch} '(&(cn=${group_name})(objectClass=group))' sAMAccountName | grep -i 'sAMAccountName: ${group_name}'" # lint:ignore:140chars
  $members.each |String $user_name, Enum['present', 'absent', 'added', 'removed'] $ensure| {
    $param_user_name = "'${user_name}'"
    $command_condition_user = "${ldapsearch} '(&(cn=${user_name})(objectClass=user))' sAMAccountName | grep -i 'sAMAccountName: ${user_name}'" # lint:ignore:140chars
    $command_condition_member = "${ldapsearch} '(&(cn=${group_name})(objectClass=group))' member | grep -i 'member: cn=${user_name}'" # lint:ignore:140chars
    $command_condition = "${command_condition_group} && ${$command_condition_user} && ${$command_condition_member}"
    if $ensure == 'present' or $ensure == 'added' {
      $command = join([
          $command_add,
          $param_user_name,
      ], ' ')
      $condition = 'unless'
    }
    elsif $ensure == 'absent' or $ensure == 'removed' {
      $command = join([
          $command_remove,
          $param_user_name,
      ], ' ')
      $condition = 'onlyif'
    }

    # notify { "adcli::ad::members::DEBUG_exec_${group_name}_${user_name}":
    #   message  => "command=${command}\ncommand=${command}\ncommand_condition=${command_condition}",
    #   withpath => true,
    # }

    if $ldapsearch {
      if $condition == 'unless' {
        exec { "adcli::ad::members:${group_name}_${user_name}_${ensure}_unless":
          path      => '/usr/bin:/bin:/usr/sbin:/sbin',
          command   => $command,
          unless    => $command_condition,
          logoutput => $log_output,
          require   => Class['adcli::install'],
        }
      } else {
        exec { "adcli::ad::members:${group_name}_${user_name}_${ensure}_onlyif":
          path      => '/usr/bin:/bin:/usr/sbin:/sbin',
          command   => $command,
          onlyif    => $command_condition,
          logoutput => $log_output,
          require   => Class['adcli::install'],
        }
      }
    } else {
      exec { "adcli::ad::members:${group_name}_${user_name}_${ensure}_always":
        path      => '/usr/bin:/bin:/usr/sbin:/sbin',
        command   => $command,
        logoutput => $log_output,
        require   => Class['adcli::install'],
      }
    }
  }
}
