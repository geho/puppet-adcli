# frozen_string_literal: true

require 'spec_helper'

describe 'adcli' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:hiera_config) { 'hiera-rspec.yaml' }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('adcli::install') }
    end
  end
end
