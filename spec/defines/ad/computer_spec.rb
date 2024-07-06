# frozen_string_literal: true

require 'spec_helper'

describe 'adcli::ad::computer' do
  let(:title) { 'namevar' }
  let(:params) { { 'host_fqdn' => 'examplehost.example.org' } }

  #
  # ensure => preset
  #
  context "with ensure => 'preset'" do
    let(:hiera_config) { 'hiera-rspec.yaml' }
    let(:pre_condition) { 'include adcli' }
    let(:params) do
      super().merge({ 'ensure' => 'preset' })
    end

    context 'with valid password' do
      let(:params) do
        super().merge(
          { 'password' => 'very_strong_password_placeholder', },
        )
      end

      it { is_expected.to compile }
      it { is_expected.to contain_exec('adcli::ad::computer:examplehost.example.org_preset_unless') }
    end
    context 'with invalid password undef' do
      let(:params) do
        super().merge(
          { 'password' => :undef, },
        )
      end

      it { is_expected.to compile.and_raise_error(%r{You must specify password to ensure preset}) }
    end
    context 'with invalid password empty' do
      let(:params) do
        super().merge(
          { 'password' => '', },
        )
      end

      it { is_expected.to compile.and_raise_error(%r{You must specify password to ensure preset}) }
    end
  end
  #
  # ensure => joined
  #
  context "with ensure => 'joined'" do
    let(:hiera_config) { 'hiera-rspec.yaml' }
    let(:pre_condition) { 'include adcli' }
    let(:params) do
      super().merge({ 'ensure' => 'joined' })
    end

    context 'with valid password' do
      let(:params) do
        super().merge(
          { 'password' => 'very_strong_password_placeholder', },
        )
      end

      it { is_expected.to compile }
      it { is_expected.to contain_exec('adcli::ad::computer:examplehost.example.org_joined_unless') }
    end
    context 'with valid one_time_password' do
      let(:params) do
        super().merge(
          { 'one_time_password' => 'very_strong_one_time_password_placeholder', },
        )
      end

      it { is_expected.to compile }
      it { is_expected.to contain_exec('adcli::ad::computer:examplehost.example.org_joined_unless') }
    end
    context 'with valid login_ccache' do
      let(:params) do
        super().merge(
          { 'login_ccache' => 'KEYRING:persistent:%%{}{uid}', },
        )
      end

      it { is_expected.to compile }
      it { is_expected.to contain_exec('adcli::ad::computer:examplehost.example.org_joined_unless') }
    end
    context 'with invalid password, one-time-password and login_ccache undef' do
      it { is_expected.to compile.and_raise_error(%r{You must specify either password or one_time_password or login_ccache to ensure joined}) }
    end
    context 'with invalid password, one-time-password and login_ccache empty' do
      let(:params) do
        super().merge(
          {
            'password'          => '',
            'one_time_password' => '',
            'login_ccache'      => '',
          },
        )
      end

      it { is_expected.to compile.and_raise_error(%r{You must specify either password or one_time_password or login_ccache to ensure joined}) }
    end
  end
  #
  # ensure => updated
  #
  context "with ensure => 'updated'" do
    let(:hiera_config) { 'hiera-rspec.yaml' }
    let(:pre_condition) { 'include adcli' }
    let(:params) do
      super().merge({ 'ensure' => 'updated' })
    end

    context 'with valid password' do
      let(:params) do
        super().merge(
          { 'password' => 'very_strong_password_placeholder', },
        )
      end

      it { is_expected.to compile }
      it { is_expected.to contain_exec('adcli::ad::computer:examplehost.example.org_joined') }
      it { is_expected.to contain_exec('adcli::ad::computer:examplehost.example.org_updated_onlyif') }
    end
    context 'with valid login_ccache' do
      let(:params) do
        super().merge(
          { 'login_ccache' => 'KEYRING:persistent:%%{}{uid}', },
        )
      end

      it { is_expected.to compile }
      it { is_expected.to contain_exec('adcli::ad::computer:examplehost.example.org_joined') }
      it { is_expected.to contain_exec('adcli::ad::computer:examplehost.example.org_updated_onlyif') }
    end
    context 'with invalid password, one-time-password and logion_ccache undef' do
      it { is_expected.to compile.and_raise_error(%r{You must specify either password or login_ccache to ensure updated}) }
    end
    context 'with invalid password, one-time-password and logion_ccache empty' do
      let(:params) do
        super().merge(
          {
            'password'          => '',
            'one_time_password' => '',
            'login_ccache'      => '',
          },
        )
      end

      it { is_expected.to compile.and_raise_error(%r{You must specify either password or login_ccache to ensure updated}) }
    end
  end
  #
  # ensure => reset
  #
  context "with ensure => 'reset'" do
    let(:hiera_config) { 'hiera-rspec.yaml' }
    let(:pre_condition) { 'include adcli' }
    let(:params) do
      super().merge({ 'ensure' => 'reset' })
    end

    context 'with valid password' do
      let(:params) do
        super().merge(
          { 'password' => 'very_strong_password_placeholder', },
        )
      end

      it { is_expected.to compile }
      it { is_expected.to contain_exec('adcli::ad::computer:examplehost.example.org_reset_onlyif') }
    end
    context 'with valid login_ccache' do
      let(:params) do
        super().merge(
          { 'login_ccache' => 'KEYRING:persistent:%%{}{uid}', },
        )
      end

      it { is_expected.to compile }
      it { is_expected.to contain_exec('adcli::ad::computer:examplehost.example.org_reset_onlyif') }
    end
    context 'with invalid password, one-time-password and logion_ccache undef' do
      it { is_expected.to compile.and_raise_error(%r{You must specify either password or login_ccache to ensure reset}) }
    end
    context 'with invalid password, one-time-password and logion_ccache empty' do
      let(:params) do
        super().merge(
          {
            'password'          => '',
            'one_time_password' => '',
            'login_ccache'      => '',
          },
        )
      end

      it { is_expected.to compile.and_raise_error(%r{You must specify either password or login_ccache to ensure reset}) }
    end
  end
  #
  # ensure => deleted
  #
  context "with ensure => 'deleted'" do
    let(:hiera_config) { 'hiera-rspec.yaml' }
    let(:pre_condition) { 'include adcli' }
    let(:params) do
      super().merge({ 'ensure' => 'deleted' })
    end

    context 'with valid password' do
      let(:params) do
        super().merge(
          { 'password' => 'very_strong_password_placeholder', },
        )
      end

      it { is_expected.to compile }
      it { is_expected.to contain_exec('adcli::ad::computer:examplehost.example.org_deleted_onlyif') }
    end
    context 'with valid login_ccache' do
      let(:params) do
        super().merge(
          { 'login_ccache' => 'KEYRING:persistent:%%{}{uid}', },
        )
      end

      it { is_expected.to compile }
      it { is_expected.to contain_exec('adcli::ad::computer:examplehost.example.org_deleted_onlyif') }
    end
    context 'with invalid password, one-time-password and logion_ccache undef' do
      it { is_expected.to compile.and_raise_error(%r{You must specify either password or login_ccache to ensure deleted}) }
    end
    context 'with invalid password, one-time-password and logion_ccache empty' do
      let(:params) do
        super().merge(
          {
            'password'          => '',
            'one_time_password' => '',
            'login_ccache'      => '',
          },
        )
      end

      it { is_expected.to compile.and_raise_error(%r{You must specify either password or login_ccache to ensure deleted}) }
    end
  end
  #
  # computer_account_as_root_k5identity => true
  #
  context 'with computer_account_as_root_k5identity => true' do
    let(:hiera_config) { 'hiera-rspec.yaml' }
    let(:pre_condition) { 'include adcli' }
    let(:params) do
      {
        'host_fqdn'                           => 'examplehost.example.org',
        'password'                            => 'very_strong_password_placeholder',
        'computer_account_as_root_k5identity' => true,
      }
    end

    it { is_expected.to compile }
    it { is_expected.to contain_file('/root/.k5identity') }
  end
  #
  # cycle over all oses
  #
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:hiera_config) { 'hiera-rspec.yaml' }
      let(:pre_condition) { 'include adcli' }
      let(:params) do
        {
          'host_fqdn'  => 'examplehost.example.org',
          'login_user' => 'administrator',
          'password'   => 'very_strong_password_placeholder'
        }
      end

      it { is_expected.to compile }
      it { is_expected.to contain_exec('adcli::ad::computer:examplehost.example.org_joined_unless') }
    end
  end
end
