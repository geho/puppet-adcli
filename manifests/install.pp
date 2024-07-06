# @summary Installs adcli
#
# @param manage_package
#   Enable or disable package management.
#   Type: Boolean
#   Default: true
# @param package_ensure
#   Ensure package is set to defined state.
#   Type: Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest']
#   Default: 'installed'
# @param package_name
#   Specify the default package name.
#   Type: String
#   Default: 'adcli'
#
# @param manage_openldap_utils
#   Enable or disable openladp utils package management.
#   Type: Boolean
#   Default: true
# @param manage_gem_inifile
#   Enable or disable inifile gem management (inifile is required to parse adcli output for facts).
#   Type: Boolean
#   Default: true
# @param ensure_gem_inifile
#   Ensure gem is set to defined state.
#   Type: Enum['present','absent','installed','purged']
#   Default: 'installed'
# @param package_name_gem_inifile
#   Specify the name of the gem package.
#   Type: String
#   Default: 'inifile'
# @param provider_gem_inifile
#   Specify the package provider of the gem package.
#   Type: String
#   Default: 'puppet_gem'
# @param source_gem_inifile
#   Specify an alternative source for the gem package.
#   Type: Optional[String]
#   Default: undef
# @param install_options_gem_inifile
#   Specify package install options.
#   Type: Array[String]
#   Default: ['--no-document']
#
# @api private
class adcli::install (
  Boolean                                                                $manage_package              = $adcli::manage_package,
  Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest'] $package_ensure              = $adcli::package_ensure,
  String                                                                 $package_name                = $adcli::package_name,
  Boolean                                                                $manage_openldap_utils       = $adcli::manage_openldap_utils,
  Boolean                                                                $manage_gem_inifile          = $adcli::manage_gem_inifile,
  Enum['present','absent','installed','purged']                          $ensure_gem_inifile          = $adcli::ensure_gem_inifile,
  String                                                                 $package_name_gem_inifile    = $adcli::package_name_gem_inifile,
  String                                                                 $provider_gem_inifile        = $adcli::provider_gem_inifile,
  Array[String]                                                          $install_options_gem_inifile = $adcli::install_options_gem_inifile,
  Optional[String]                                                       $source_gem_inifile          = $adcli::source_gem_inifile,
) {
  if $manage_package == true {
    package { 'adcli-package':
      ensure => $package_ensure,
      name   => $package_name,
    }
  }
  if $manage_openldap_utils == true {
    require openldap::utils
  }
  if $manage_gem_inifile == true {
    package { 'puppet-gem-inifile':
      ensure          => $ensure_gem_inifile,
      name            => $package_name_gem_inifile,
      provider        => $provider_gem_inifile,
      source          => $source_gem_inifile,
      install_options => $install_options_gem_inifile,
    }
  }
}
