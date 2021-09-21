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
        is_expected.to contain_file('vanilla-01 start script')
          .with(
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
          .with_content(%r{^  -server.hostname "My Rust Server" \\$})
          .with_content(%r{^  -server.identity "vanilla-01" \\$})
          .with_content(%r{^  -server.level "Procedural Map" \\$})
          .with_content(%r{^  -server.seed 163340768 \\$})
          .with_content(%r{^  -server.worldsize 3000 \\$})
          .with_content(%r{^  -server.saveinterval 300 \\$})
          .with_content(%r{^  -server.globalchat true \\$})
          .with_content(%r{^  -server.description "This is my Rust server."$})
          .that_requires('Exec[install vanilla-01 server]')
      }
    end
  end
end
