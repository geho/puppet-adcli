# frozen_string_literal: true

# https://github.com/puppetlabs/puppet-specifications/blob/master/language/func-api.md#the-4x-api
Puppet::Functions.create_function(:"adcli::computer_arguments") do
  dispatch :computer_arguments do
    return_type 'Hash'
    optional_param 'Optional[String]',                  :os_name
    optional_param 'Optional[String]',                  :os_version
    optional_param 'Optional[String]',                  :os_service_pack
    optional_param 'Optional[String]',                  :description
    optional_param 'Optional[Boolean]',                 :preset_user_principal
    optional_param 'Optional[String]',                  :user_principal
    optional_param 'Array[String]',                     :service_names
    optional_param 'Array[String]',                     :service_principals
    optional_param 'Array[String]',                     :attributes
    optional_param 'Optional[Boolean]',                 :trusted_for_delegation
    optional_param 'Optional[Boolean]',                 :dont_expire_password
    optional_param 'Optional[Variant[String,Integer]]', :computer_password_lifetime
    optional_param 'Optional[Boolean]',                 :account_disable
    # optional_param 'Optional[Boolean]',                 :computer_account_as_root_k5identity
    optional_param 'Optional[Boolean]',                 :add_samba_data
    optional_param 'Optional[Stdlib::Absolutepath]',    :samba_data_tool

    repeated_param 'Any',                               :_args
  end
  # the function below is called by puppet and and must match
  # the name of the puppet function above.
  def computer_arguments(os_name, os_version, os_service_pack, description, preset_user_principal, user_principal,
                         service_names, service_principals, attributes, trusted_for_delegation, dont_expire_password, computer_password_lifetime,
                         account_disable, add_samba_data, samba_data_tool)
    result = {}
    fact_os = Facter.value(:os).to_h
    fact_os_release = fact_os[:release].to_h

    if (os_name.is_a? String) && (os_name.strip != '')
      result['os_name'] = os_name
      result['os_name_option'] = "--os-name='#{os_name}'"
    else
      result['os_name'] = fact_os[:name].to_s
      result['os_name_option'] = "--os-name='#{result['os_name']}'"
    end

    if (os_version.is_a? String) && (os_version.strip != '')
      result['os_version'] = os_version
      result['os_version_option'] = "--os-version='#{os_version}'"
    else
      result['os_version'] = fact_os_release[:major].to_s
      result['os_version_option'] = "--os-version='#{result['os_version']}'"
    end

    if (os_service_pack.is_a? String) && (os_service_pack.strip != '')
      result['os_service_pack'] = os_service_pack
      result['os_service_pack_option'] = "--os-service-pack='#{os_service_pack}'"
    else
      result['os_service_pack'] = fact_os_release[:minor].to_s
      result['os_service_pack_option'] = "--os-service-pack='#{result['os_service_pack']}'"
    end

    if (description.is_a? String) && (description.strip != '')
      result['description'] = description
      result['description_option'] = "--description='#{description}'"
    else
      result['description'] = ''
      result['description_option'] = ''
    end

    if preset_user_principal == true
      result['preset_user_principal'] = preset_user_principal
      result['preset_user_principal_option'] = '--user-principal'
    else
      result['preset_user_principal'] = false
      result['preset_user_principal_option'] = ''
    end

    if (user_principal.is_a? String) && (user_principal != '')
      result['user_principal'] = user_principal
      result['user_principal_option'] = "--user-principal='#{user_principal}'"
    else
      result['user_principal'] = false
      result['user_principal_option'] = ''
    end

    if (service_names.is_a? Array) && (service_names != [])
      result['service_names'] = service_names
      result['service_names_option'] = "--service-name=#{service_names.join(' --service-name=')}"
    else
      result['service_names'] = []
      result['service_names_option'] = ''
    end

    if (service_principals.is_a? Array) && (service_principals != [])
      result['service_principals'] = service_principals
      result['service_principals_option'] = "--service-name='#{service_names.join('\' --service-name=\'')}'"
    else
      result['service_principals'] = []
      result['service_principals_option'] = ''
    end

    if (attributes.is_a? Array) && (attributes != [])
      result['attributes'] = attributes
      result['attributes_option'] = "--setattr='#{attributes.join('\' --setattr=\'')}'"
    else
      result['attributes'] = []
      result['attributes_option'] = ''
    end

    if trusted_for_delegation == true
      result['trusted_for_delegation'] = trusted_for_delegation
      result['trusted_for_delegation_option'] = "--trusted-for-delegation=#{trusted_for_delegation}"
    else
      result['trusted_for_delegation'] = false
      result['trusted_for_delegation_option'] = ''
    end

    if dont_expire_password == true
      result['dont_expire_password'] = trusted_for_delegation
      result['dont_expire_password_option'] = "--dont-expire-password=#{dont_expire_password}"
    else
      result['dont_expire_password'] = false
      result['dont_expire_password_option'] = ''
    end

    if (computer_password_lifetime.is_a? String) && (computer_password_lifetime.strip != '') || (computer_password_lifetime.is_a? Integer)
      result['computer_password_lifetime'] = computer_password_lifetime.to_s
      result['computer_password_lifetime_option'] = "--computer-password-lifetime=#{computer_password_lifetime}"
    else
      result['computer_password_lifetime'] = ''
      result['computer_password_lifetime_option'] = ''
    end

    if account_disable == true
      result['account_disable'] = account_disable
      result['account_disable_option'] = "--account-disable=#{account_disable}"
    else
      result['account_disable'] = false
      result['account_disable_option'] = ''
    end

    if add_samba_data == true
      result['add_samba_data'] = add_samba_data
      result['add_samba_data_option'] = '--add-samba-data'
    else
      result['add_samba_data'] = false
      result['add_samba_data_option'] = ''
    end

    if (samba_data_tool.is_a? String) && (samba_data_tool != '')
      result['samba_data_tool'] = samba_data_tool
      result['samba_data_tool_option'] = "--samba-data-tool='#{samba_data_tool}'"
    else
      result['samba_data_tool'] = :undef
      result['samba_data_tool_option'] = ''
    end

    result
  end

  # you can define other helper methods in this code block as well
end
