# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   rustserver::server { 'namevar': }
define rustserver::server (
  String $install_dir,
  Enum['present', 'absent'] $ensure = present,
) {

  exec { "install ${title} server":
    command => "${rustserver::steamcmd_path} +login +force_install_dir ${install_dir} +app_update 258550 +quit",
    creates => $install_dir,
  }
}
