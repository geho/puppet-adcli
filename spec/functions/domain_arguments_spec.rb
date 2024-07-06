# frozen_string_literal: true

require 'spec_helper'

describe 'adcli::domain_arguments' do
  domain = :undef
  domain_realm = :undef
  domain_controller = :undef
  domain_basedn = :undef
  domain_computer_ou = :undef
  domain_user_ou = :undef
  domain_group_ou = :undef
  login_type = :undef
  login_user = :undef
  password = :undef
  login_ccache = :undef
  one_time_password = :undef
  host_name = :undef
  host_fqdn = :undef
  host_keytab = :undef
  computer_name = :undef
  ldap_auth_type = :undef
  ldap_binddn = :undef
  ldap_bindpw = :undef
  ldaps_cacert_path = :undef
  it {
    is_expected.to run.with_params(domain, domain_realm, domain_controller,
                                   domain_basedn, domain_computer_ou, domain_user_ou, domain_group_ou,
                                   login_type, login_user, password, login_ccache, one_time_password,
                                   host_name, host_fqdn, host_keytab, computer_name,
                                   ldap_auth_type, ldap_binddn, ldap_bindpw, ldaps_cacert_path)
  }
end
