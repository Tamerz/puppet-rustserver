# frozen_string_literal: true

require 'spec_helper'

describe 'rustserver::server' do
  let(:pre_condition) { 'include rustserver' }
  let(:title) { 'vanilla-01' }
  let(:params) do
    {
      install_dir: '/opt/rustservers/vanilla-01',
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
    end
  end
end
