# frozen_string_literal: true

require 'spec_helper'

describe 'adcli::install' do
  let(:params) do
    {
      'manage_package'              => true,
      'package_ensure'              => 'installed',
      'package_name'                => 'adcli',
      'manage_openldap_utils'       => true,
      'manage_gem_inifile'          => true,
      'ensure_gem_inifile'          => 'installed',
      'package_name_gem_inifile'    => 'inifile',
      'provider_gem_inifile'        => 'puppet_gem',
      'source_gem_inifile'          => 'https://rubygems.org/downloads/inifile-3.0.0.gem',
      'install_options_gem_inifile' => ['--no-document'],
    }
  end

  context 'with manage_package => true' do
    let(:hiera_config) { 'hiera-rspec.yaml' }
    let(:params) do
      super().merge(
        {
          'manage_package'              => true,
          'manage_openldap_utils'       => false,
          'manage_gem_inifile'          => false,
        },
      )
    end

    it { is_expected.to contain_package('adcli-package') }
    it { is_expected.to compile.with_all_deps }
  end
  context 'with manage_openldap_utils => true' do
    let(:hiera_config) { 'hiera-rspec.yaml' }
    let(:params) do
      super().merge(
        {
          'manage_package'              => false,
          'manage_openldap_utils'       => true,
          'manage_gem_inifile'          => false,
        },
      )
    end

    it { is_expected.to contain_class('openldap::utils') }
    it { is_expected.to compile.with_all_deps }
  end
  context 'with manage_gem_inifile => true' do
    let(:hiera_config) { 'hiera-rspec.yaml' }
    let(:params) do
      super().merge(
        {
          'manage_package'              => false,
          'manage_openldap_utils'       => false,
          'manage_gem_inifile'          => true,
        },
      )
    end

    it { is_expected.to contain_package('puppet-gem-inifile') }
    it { is_expected.to compile.with_all_deps }
  end
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:hiera_config) { 'hiera-rspec.yaml' }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('adcli-package') }
      it { is_expected.to contain_class('openldap::utils') }
      it { is_expected.to contain_package('puppet-gem-inifile') }
    end
  end
end
