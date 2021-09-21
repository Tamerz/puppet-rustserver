# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   rustserver::server { 'namevar': }
define rustserver::server (
  String $install_dir,
  String $rcon_password,
  Enum['present', 'absent'] $ensure = present,
  String $ip_address = '0.0.0.0',
  String $rcon_ip_address = '0.0.0.0',
  Integer $port = 28015,
  Integer $rcon_port = 28016,
  Integer $max_players = 10,
  Integer[1, 2147483647] $seed = 163340768,
  Integer[1000, 6000] $worldsize = 3000,
  Integer $saveinterval = 300,
  Boolean $globalchat = true,
  String $hostname = 'My Rust Server',
  String $description = 'This is my Rust server.',
  String $identity = $title,
  String $level = 'Procedural Map',
  String $user = $rustserver::user,
  String $group = $rustserver::group,
) {

  exec { "install ${title} server":
    command => "${rustserver::steamcmd_path} +login +force_install_dir ${install_dir} +app_update 258550 +quit",
    creates => $install_dir,
  }

  file { "${title} start script":
    ensure  => file,
    path    => "${install_dir}/start.sh",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => epp(
      'rustserver/start.sh.epp',
      {
        'install_dir'     => $install_dir,
        'ip_address'      => $ip_address,
        'port'            => $port,
        'rcon_ip_address' => $rcon_ip_address,
        'rcon_port'       => $rcon_port,
        'rcon_password'   => $rcon_password,
        'max_players'     => $max_players,
        'seed'            => $seed,
        'worldsize'       => $worldsize,
        'saveinterval'    => $saveinterval,
        'globalchat'      => $globalchat,
        'hostname'        => $hostname,
        'identity'        => $identity,
        'level'           => $level,
        'description'     => $description,
      }
    ),
    require => Exec["install ${title} server"],
  }

  file { "/etc/systemd/system/rust-${title}.service":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    seltype => 'systemd_unit_file_t',
    content => epp(
      'rustserver/service.epp',
      {
        'title'       => $title,
        'user'        => $user,
        'group'       => $group,
        'install_dir' => $install_dir,
      }
    ),
    require => File["${title} start script"],
  }

  exec { 'systemd-daemon-reload':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
    subscribe   => File["/etc/systemd/system/rust-${title}.service"],
  }
}
