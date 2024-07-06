# frozen_string_literal: true

# https://github.com/puppetlabs/puppet-specifications/blob/master/language/func-api.md#the-4x-api
Puppet::Functions.create_function(:"adcli::domain_arguments") do
  dispatch :domain_arguments do
    return_type 'Hash'
    # the domain name in fqdn format, e.g. 'example.org'
    optional_param 'Optional[Stdlib::Fqdn]',            :domain
    # the domain realm in fqdn format, e.g. 'EXAMPLE.ORG'
    optional_param 'Optional[Stdlib::Fqdn]',            :domain_realm
    # the domain controller in fqdn format, e.g. 'dc.example.org'
    optional_param 'Optional[Stdlib::Fqdn]',            :domain_controller
    # the ldap base distinguished name (dn), e.g. 'dc=example,dc=org'
    optional_param 'Optional[String]',                  :domain_basedn
    # the ldap distinguished name (dn) where computers are located in domain tree, e.g. 'cn=Computers,dc=example,dc=org'
    optional_param 'Optional[String]',                  :domain_computer_ou
    # the ldap distinguished name (dn) where users are located in domain tree, e.g. 'cn=Users,dc=example,dc=org'
    optional_param 'Optional[String]',                  :domain_user_ou
    # the ldap distinguished name (dn) where users are located in domain tree, e.g. 'cn=Users,dc=example,dc=org'
    optional_param 'Optional[String]',                  :domain_group_ou

    # the login type to use for domain authentication and authorization, use either the computer account or the specified login_user
    optional_param "Optional[Enum['computer','user']]", :login_type
    # the login user name to use for domain authentication and authorization
    optional_param 'Optional[String]',                  :login_user
    # the password to use for domain authentication and authorization with login_user
    optional_param 'Optional[String]',                  :password
    # the krb5 ccache to use for domain authentication and authorization with login_user
    optional_param 'Optional[String]',                  :login_ccache
    # the one time password set during preset to a computer account and used during join
    # implies login_type is 'computer' and login_user is computer account name
    optional_param 'Optional[String]',                  :one_time_password

    # the host_name to use for calculating computer_name or computer_account name if parameters not specified
    optional_param 'Optional[String]',                  :host_name
    # the host_fqdn to use for preset and join
    optional_param 'Optional[String]',                  :host_fqdn
    # the host_keytab to use for domain authentication and authorization
    optional_param 'Optional[String]',                  :host_keytab
    # the computer_name to use for domain authentication, authorization, preset and join
    optional_param 'Optional[String]',                  :computer_name

    # the ldap auth type to use for domain authentication to check for user/group existence
    optional_param "Optional[Enum['insecure', 'tls', 'gss_spnego', 'gssapi']]", :ldap_auth_type
    # the ldap auth account to use for domain authentication to check for user/group existence
    optional_param 'Optional[String]',                  :ldap_binddn
    # the ldap auth password to use for domain authentication to check for user/group existence
    optional_param 'Optional[String]',                  :ldap_bindpw
    # the ca certificate chain file for ldaps authentication
    optional_param 'Optional[String]',                  :ldaps_cacert_path

    repeated_param 'Any',                               :_args
  end
  # the function below is called by puppet and and must match
  # the name of the puppet function above.
  # def domain_arguments(fact_networking, domain, domain_realm, domain_controller,
  def domain_arguments(domain, domain_realm, domain_controller,
                       domain_basedn, domain_computer_ou, domain_user_ou, domain_group_ou,
                       login_type, login_user, password, login_ccache, one_time_password,
                       host_name, host_fqdn, host_keytab, computer_name,
                       ldap_auth_type, ldap_binddn, ldap_bindpw, ldaps_cacert_path, *_args)
    result = {}
    fact_networking = Facter.value(:networking).to_h

    if (domain.is_a? String) && (domain.strip != '')
      result['domain'] = domain
      result['domain_option'] = "--domain='#{domain}'"
    else
      result['domain'] = fact_networking[:domain].to_s
      result['domain_option'] = ''
    end
    result['domain_param'] = "'#{result['domain']}'"

    if (domain_realm.is_a? String) && (domain_realm.strip != '')
      result['domain_realm'] = domain_realm
      result['domain_realm_option'] = "--domain-realm='#{domain_realm.upcase}'"
    else
      result['domain_realm'] = result['domain'].upcase
      result['domain_realm_option'] = ''
    end
    result['domain_realm_param'] = "'#{result['domain_realm']}'"

    if (domain_controller.is_a? String) && (domain_controller.strip != '')
      result['domain_controller'] = domain_controller
      result['domain_controller_param'] = "'#{domain_controller}'"
      result['domain_controller_option'] = "--domain-controller='#{domain_controller}'"
    else
      result['domain_controller'] = :undef
      result['domain_controller_param'] = ''
      result['domain_controller_option'] = ''
    end

    result['domain_basedn'] =
      if (domain_basedn.is_a? String) && (domain_basedn.strip != '')
        domain_basedn
      else
        "dc=#{result['domain'].split('.').join(',dc=')}"
      end
    result['domain_basedn_param'] = "'#{result['domain_basedn']}'"

    if (domain_computer_ou.is_a? String) && (domain_computer_ou.strip != '')
      result['domain_computer_ou'] = domain_computer_ou
      result['domain_computer_ou_option'] = "--domain-ou='#{domain_computer_ou}'"
    else
      result['domain_computer_ou'] = "cn=Computers,#{result['domain_basedn']}"
      result['domain_computer_ou_option'] = ''
    end
    result['domain_computer_ou_param'] = "'#{result['domain_computer_ou']}'"

    if (domain_user_ou.is_a? String) && (domain_user_ou.strip != '')
      result['domain_user_ou'] = domain_user_ou
      result['domain_user_ou_option'] = "--domain-ou='#{domain_user_ou}'"
    else
      result['domain_user_ou'] = "cn=Users,#{result['domain_basedn']}"
      result['domain_user_ou_option'] = ''
    end
    result['domain_user_ou_param'] = "'#{result['domain_user_ou']}'"

    if (domain_group_ou.is_a? String) && (domain_group_ou.strip != '')
      result['domain_group_ou'] = domain_group_ou
      result['domain_group_ou_option'] = "--domain-ou='#{domain_group_ou}'"
    else
      result['domain_group_ou'] = "cn=Users,#{result['domain_basedn']}"
      result['domain_group_ou_option'] = ''
    end
    result['domain_group_ou_param'] = "'#{result['domain_group_ou']}'"

    if (login_type.is_a? String) && (login_type.strip != '')
      result['login_type'] = login_type
      result['login_type_option'] = "--login-type='#{login_type}'"
    else
      result['login_type'] = :undef
      result['login_type_option'] = ''
    end

    if (login_user.is_a? String) && (login_user.strip != '')
      result['login_user'] = login_user
      result['login_user_param'] = "'#{login_user}'"
      result['login_user_option'] = "--login-user='#{login_user}'"
    else
      result['login_user'] = :undef
      result['login_user_option'] = ''
    end

    if (password.is_a? String) && (password.strip != '')
      result['password'] = password
      result['password_param'] = "'#{password}'"
      result['stdout_password'] = "echo -n '#{password}' |"
      result['stdin_password'] = '--stdin-password'
    else
      result['login_password'] = :undef
      result['login_password_param'] = ''
      result['stdout_password'] = ''
      result['stdin_password'] = ''
    end

    if (login_ccache.is_a? String) && (login_ccache.strip != '')
      result['login_ccache'] = login_ccache
      result['login_ccache_option'] = "--login-ccache='#{login_ccache}'"
      result['login_ccache_param'] = "'#{login_ccache}'"
    else
      result['login_ccache'] = :undef
      result['login_ccache_option'] = ''
      result['login_ccache_param'] = ''
    end

    if (one_time_password.is_a? String) && (one_time_password.strip != '')
      result['one_time_password'] = one_time_password
      result['one_time_password_option'] = "--one-time-password='#{one_time_password}'"
      result['one_time_password_param'] = "'#{one_time_password}'"
    else
      result['one_time_password'] = :undef
      result['one_time_password_option'] = ''
      result['one_time_password_param'] = ''
    end

    result['host_name'] =
      if (host_name.is_a? String) && (host_name.strip != '')
        host_name
      else
        fact_networking[:hostname].to_s
      end
    result['host_name_param'] = "'#{host_name}'"

    if (host_fqdn.is_a? String) && (host_fqdn.strip != '')
      result['host_fqdn'] = host_fqdn
      result['host_fqdn_option'] = "--host-fqdn='#{host_fqdn}'"
    else
      result['host_fqdn'] = fact_networking[:fqdn].to_s
      result['host_fqdn_option'] = ''
    end
    result['host_fqdn_param'] = "'#{host_fqdn}'"

    if (host_keytab.is_a? String) && (host_keytab.strip != '')
      result['host_keytab'] = host_keytab
      result['host_keytab_option'] = "--host-keytab='#{host_keytab}'"
    else
      result['host_keytab'] = '/etc/krb5.keytab'
      result['host_keytab_option'] = ''
    end
    result['host_keytab_param'] = "'#{host_keytab}'"

    if (computer_name.is_a? String) && (computer_name.strip != '')
      result['computer_name'] = computer_name
      result['computer_name_option'] = "--computer-name='#{computer_name}'"
    else
      result['computer_name'] = result['host_name'].upcase
      result['computer_name_option'] = ''
    end
    result['computer_name_param'] = "'#{computer_name}'"

    result['computer_account'] = "#{result['computer_name']}$"
    result['computer_account_param'] = "'#{result['computer_account']}'"

    if (ldap_auth_type == 'insecure') || (ldap_auth_type == 'tls') || (ldap_auth_type == 'gss_spnego') || (ldap_auth_type == 'gssapi')
      result['ldap_auth_type'] = ldap_auth_type
      result['ldap_binddn'] =
        if (ldap_binddn.is_a? String) && (ldap_binddn != '')
          ldap_binddn
        else
          ''
        end
      result['ldap_bindpw'] =
        if (ldap_bindpw.is_a? String) && (ldap_bindpw != '')
          ldap_bindpw
        else
          ''
        end
      result['ldaps_cacert_path'] =
        if (ldaps_cacert_path.is_a? String) && (ldaps_cacert_path != '')
          ldaps_cacert_path
        else
          ''
        end
    else
      result['ldap_auth_type'] = ''
      result['ldap_binddn'] = ''
      result['ldap_bindpw'] = ''
      result['ldaps_cacert_path'] = ''
    end

    result
  end

  # you can define other helper methods in this code block as well
end
