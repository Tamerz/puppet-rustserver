# frozen_string_literal: true

require 'spec_helper'

describe 'rustserver::server' do
  let(:pre_condition) { 'include rustserver' }
  let(:title) { 'vanilla-01' }
  let(:params) do
    {
      install_dir: '/opt/rustservers/vanilla-01',
      rcon_password: 's0s3cret',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it {
        is_expected.to contain_exec('install vanilla-01 server').with(
          'command' => '/opt/steamcmd/steamcmd.sh +login +force_install_dir /opt/rustservers/vanilla-01 +app_update 258550 +quit',
          'creates' => '/opt/rustservers/vanilla-01',
        )
      }

      it {
        is_expected.to contain_file('vanilla-01 start script').with(
          'ensure' => 'file',
          'path'   => '/opt/rustservers/vanilla-01/start.sh',
          'owner'  => 'root',
          'mode'   => '0755',
        )
        .with_content(%r{^/opt/rustservers/vanilla-01/RustDedicated -batchmode -nographics \\$})
        .with_content(%r{^  -server.ip 0.0.0.0 \\$})
        .with_content(%r{^  -server.port 28015 \\$})
        .with_content(%r{^  -rcon.ip 0.0.0.0 \\$})
        .with_content(%r{^  -rcon.port 28016 \\$})
        .with_content(%r{^  -rcon.password "s0s3cret" \\$})
        .with_content(%r{^  -server.maxplayers 10 \\$})
        #.that_contains(%r{'-server.ip 0.0.0.0}-server.port 28015 -rcon.ip 0.0.0.0 -rcon.port 28016 -rcon.password "s0s3cret" -server.maxplayers 10 -server.hostname "My Rust Server" ')
      }
    end
  end
end
