# frozen_string_literal: true

require 'date'
require 'English'

Facter.add(:ad) do
  # https://puppet.com/docs/puppet/latest/fact_overview.html
  confine kernel: 'Linux'
  setcode do
    ad_hash = { 'computer' => {}, 'domain' => {} }
    networking = Facter.value(:networking)
    domain = networking.fetch('domain', '')
    computer_name = networking.fetch('hostname', '').upcase
    computer_account = computer_name + '$'
    command_computer_kinit = 'kinit -k -t /etc/krb5.keytab "' + computer_account + '"'
    command_computer_joined = 'adcli testjoin'
    command_domain_info = 'adcli info ' + domain
    command_computer_info = 'adcli show-computer --login-ccache --login-type=computer'
    ad_hash['computer']['computer_name'] = computer_name
    ad_hash['computer']['computer_account'] = computer_account
    ad_hash['computer']['computer_joined'] = 'unknown'
    if Facter::Util::Resolution.which('adcli')
      begin
        Facter::Util::Resolution.exec(command_computer_joined)
        ad_hash['computer']['computer_joined'] = if $CHILD_STATUS.exitstatus == 0
                                                   'true'
                                                 else
                                                   'false'
                                                 end
      rescue
        nil
      end
    end
    if Facter::Util::Resolution.which('adcli') && domain != ''
      begin
        require 'inifile'
        ad_info_ini = Facter::Util::Resolution.exec(command_domain_info)
        ad_info_hash = IniFile.new(content: ad_info_ini).to_h
        ad_info_hash.each do |section, section_hash|
          sec = section.tr('-', '_').strip
          unless ad_hash.key?(sec)
            ad_hash[sec] = {}
          end
          section_hash.each do |name, value|
            nam = name.tr('-', '_').strip
            if sec == 'domain'
              if nam == 'domain_name'
                ad_hash[sec][nam] = value
                ad_hash[sec]['domain_realm'] = value.upcase
              elsif nam == 'domain_controller_flags'
                ad_hash[sec][nam] = value.split(' ')
              else
                ad_hash[sec][nam] = value
              end
            else
              ad_hash[sec][nam] = value
            end
          end
        end
        computer_info_txt = Facter::Util::Resolution.exec(command_computer_info)
        if computer_info_txt == ''
          computer_info_txt = "error:\n not authenticated or autorized\n"
          # 2nd attempt to fetch computer info with authentication
          if Facter::Util::Resolution.which('kinit') && computer_account != '$'
            begin
              Facter::Util::Resolution.exec(command_computer_kinit)
              computer_info_txt = Facter::Util::Resolution.exec(command_computer_info)
              if computer_info_txt == ''
                computer_info_txt = "error:\n authentication failed - not authenticated or authorized\n"
              end
            rescue
              nil
            end
          end
        end
        name = ''
        unix_time_start = 0x019DB1DED53E8000
        ticks_per_second = 10_000_000
        computer_info_txt.each_line do |line|
          if %r{^\w+:$}.match?(line)
            name = line.tr(':', '').strip
            ad_hash['computer'][name] = if name == 'servicePrincipalName'
                                          []
                                        else
                                          ''
                                        end
          else
            value = line.strip
            if name == 'servicePrincipalName'
              ad_hash['computer'][name].push(value)
            elsif name == 'pwdLastSet'
              unix_time = (value.to_i - unix_time_start) / ticks_per_second
              date_time = Time.at(unix_time).to_datetime
              ad_hash['computer'][name] = value
              ad_hash['computer']['pwdLastSetUnix'] = unix_time.to_s
              ad_hash['computer']['pwdLastSetDateTime'] = date_time.to_s
              total_age_seconds = Time.now - Time.at(unix_time)
              days = (total_age_seconds / 86_400).to_i
              hours = ((total_age_seconds / 3600) % 24).to_i
              minutes = ((total_age_seconds % 3600) / 60).to_i
              seconds = ((total_age_seconds % 3600) % 60).to_i
              ad_hash['computer']['computer_account_pwd_age'] = '%0d-%02d:%02d:%02d' % [days, hours, minutes, seconds]
            else
              ad_hash['computer'][name] = value
            end
          end
        end
      rescue LoadError
        ad_hash['error'] = 'gem inifile not found. Cannot parse adcli output.'
        nil
      rescue
        nil
      end
    end
    ad_hash
  end
end
