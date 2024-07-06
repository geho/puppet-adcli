# frozen_string_literal: true

require 'spec_helper'

describe 'adcli::computer_arguments' do
  # please note that these tests are examples only
  # you will need to replace the params and return value
  # with your expectations
  # it { is_expected.to run.with_params(2).and_return(4) }
  # it { is_expected.to run.with_params(4).and_return(8) }
  # it { is_expected.to run.with_params(nil).and_raise_error(StandardError) }
  os_name = :undef
  os_version = :undef
  os_service_pack = :undef
  description = :undef
  preset_user_principal = :undef
  user_principal = :undef
  service_names = []
  service_principals = []
  attributes = []
  trusted_for_delegation = :undef
  dont_expire_password = :undef
  computer_password_lifetime = :undef
  account_disable = :undef
  add_samba_data = :undef
  samba_data_tool = :undef
  it {
    is_expected.to run.with_params(os_name, os_version, os_service_pack, description, preset_user_principal, user_principal,
                                   service_names, service_principals, attributes, trusted_for_delegation, dont_expire_password,
                                   computer_password_lifetime, account_disable, add_samba_data, samba_data_tool)
  }
end
