require 'spec_helper'

describe 'partekflow' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "partekflow class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('partekflow::install') }
          it { is_expected.to contain_class('partekflow::config') }
          it { is_expected.to contain_class('partekflow::service') }
          it { is_expected.to contain_class('partekflow::install').that_comes_before('Class[partekflow::config]') }
          it { is_expected.to contain_class('partekflow::service').that_subscribes_to('Class[partekflow::config]') }

          it { is_expected.to contain_group('flowuser').with(
            'ensure'   => 'present',
            'gid' => '499',
          ) }

          it { is_expected.to contain_user('flow').with(
            'ensure'     => 'present',
            'uid'        => '499',
            'gid'        => '499',
            'system'     => true,
            'comment'    => 'Partek Flow daemon',
            'managehome' => true,
            'home'       => '/home/flow',
            'shell'      => '/bin/sh',
            'require'    => 'Group[flowuser]',
          ) }

          it { is_expected.to contain_package('partekflow').with(
            'ensure'  => 'present',
            'require' => 'User[flow]',
          ) }

          it { is_expected.to contain_service('partekflowd').with(
            'ensure'     => 'running',
            'enable'     => 'true',
            'hasstatus'  => 'true',
            'hasrestart' => 'true',
          ) }
        end

        context "partekflow class with package_ensure is set to latest" do
          let(:params){
            {
              :package_ensure => 'latest',
            }
          }

          it { is_expected.to contain_package('partekflow').with_ensure('latest') }
        end

        context "partekflow class with package_ensure is set to version" do
          let(:params){
            {
              :package_ensure => '1.1.1',
            }
          }

          it { is_expected.to contain_package('partekflow').with_ensure('1.1.1') }
        end

        context "partekflow class with package_name set to foo" do
          let(:params){
            {
              :package_name => 'foo',
            }
          }

          it { is_expected.to_not contain_package('partekflow') }
          it { is_expected.to contain_package('foo').with_ensure('present') }
        end

        context "partekflow class with service_enable set to false" do
          let(:params){
            {
              :service_enable => false,
            }
          }

          it { is_expected.to contain_service('partekflowd').with_enable('false') }
        end

        context "partekflow class with service_ensure set to stopped" do
          let(:params){
            {
              :service_ensure => 'stopped',
            }
          }

          it { is_expected.to contain_service('partekflowd').with_ensure('stopped') }
        end

        context "partekflow class with service_ensure set to fooed" do
          let(:params){
            {
              :service_ensure => 'fooed',
            }
          }

          it { expect { is_expected.to contain_service('partekflowd') }.to raise_error(Puppet::Error, /parameter 'service_ensure' expects a match for Enum/) }
        end

        context "partekflow class with service_name set to foo" do
          let(:params){
            {
              :service_name => 'foo',
            }
          }

          it { is_expected.to contain_service('foo') }
        end

        context "partekflow class with user_comment set to foofighter" do
          let(:params){
            {
              :user_comment => 'foofighter',
            }
          }

          it { is_expected.to contain_user('flow').with_comment('foofighter') }
        end

        context "partekflow class with user_ensure set to absent" do
          let(:params){
            {
              :user_ensure => 'absent',
            }
          }

          it { is_expected.to contain_group('flowuser').with_ensure('absent') }
          it { is_expected.to contain_user('flow').with_ensure('absent') }
        end

        context "partekflow class with user_ensure set to foo" do
          let(:params){
            {
              :user_ensure => 'foo',
            }
          }

          it { expect { is_expected.to contain_group('flowuser') }.to raise_error(Puppet::Error, /parameter 'user_ensure' expects a match for Enum/) }
          it { expect { is_expected.to contain_user('flow') }.to raise_error(Puppet::Error, /parameter 'user_ensure' expects a match for Enum/) }
        end

        context "partekflow class with user_gid set to 400" do
          let(:params){
            {
              :user_gid => 400,
            }
          }

          it { is_expected.to contain_group('flowuser').with_gid('400') }
          it { is_expected.to contain_user('flow').with_gid('400') }
        end

        context "partekflow class with user_gid set to 1000" do
          let(:params){
            {
              :user_gid => 1000,
            }
          }

          it { expect { is_expected.to contain_group('flowuser') }.to raise_error(Puppet::Error, /'user_gid' expects an Integer\[1, 499\] value, got Integer\[1000, 1000\]/) }
        end

        context "partekflow class with user_groupname set to foos" do
          let(:params){
            {
              :user_groupname => 'foos',
            }
          }
          it { is_expected.to contain_group('foos') }
        end

        context "partekflow class with user_home set to /opt/flow" do
          let(:params){
            {
              :user_home => '/opt/flow',
            }
          }
          it { is_expected.to contain_user('flow').with_home('/opt/flow') }
        end

        context "partekflow class with user_home set to relative path ../flow" do
          let(:params){
            {
              :user_home => '../flow',
            }
          }
          it { expect { is_expected.to contain_user('flow') }.to raise_error(Puppet::Error, /parameter 'user_home' expects a match for Variant\[Stdlib::Windowspath = Pattern/) }
        end

        context "partekflow class with user_name set to foo" do
          let(:params){
            {
              :user_name => 'foo',
              :user_home => '/home/foo',
            }
          }
          it { is_expected.to contain_user('foo').with(
            'ensure'     => 'present',
            'uid'        => '499',
            'gid'        => '499',
            'system'     => true,
            'comment'    => 'Partek Flow daemon',
            'managehome' => true,
            'home'       => '/home/foo',
            'shell'      => '/bin/sh',
          ) }
        end

        context "partekflow class with user_shell set to /bin/bash" do
          let(:params){
            {
              :user_shell => '/bin/bash',
            }
          }

          it { is_expected.to contain_user('flow').with_shell('/bin/bash') }
        end

        context "partekflow class with user_shell set to bash" do
          let(:params){
            {
              :user_shell => 'bash',
            }
          }

          it { expect { is_expected.to contain_user('flow') }.to raise_error(Puppet::Error, /parameter 'user_shell' expects a match for Variant\[Stdlib::Windowspath = Pattern/) }
        end

        context "partekflow class with user_uid set to 400" do
          let(:params){
            {
              :user_uid => 400,
            }
          }

          it { is_expected.to contain_user('flow').with_uid('400') }
        end

        context "partekflow class with user_uid set to 1000" do
          let(:params){
            {
              :user_uid => 1000,
            }
          }

          it { expect { is_expected.to contain_user('flow') }.to raise_error(Puppet::Error, /'user_uid' expects an Integer\[1, 499\] value, got Integer\[1000, 1000\]/) }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'partekflow class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('partekflow') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
