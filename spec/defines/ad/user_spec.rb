# frozen_string_literal: true

require 'spec_helper'

describe 'adcli::ad::user' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      'domain_controller' => 'dc.example.org',
      'domain_dn'         => 'ou=Users,ou=Accounts,dc=example,dc=org',
      'user_name'         => 'linuxuser',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:hiera_config) { 'hiera-rspec.yaml' }
      let(:pre_condition) { 'include adcli' }
      let(:params) do
        super().merge(
          {
            'login_user' => 'administrator',
            'password'   => 'very_strong_password_placeholder',
          },
        )
      end

      it { is_expected.to compile }
      it { is_expected.to contain_exec('adcli::ad::user:linuxuser_created_unless') }
    end
  end
end
