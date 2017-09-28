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

          it { is_expected.to contain_package('partekflow').with_ensure('present') }

          it { is_expected.to contain_service('partekflowd') }
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

        context "partekflow class with package_manage is set to false" do
          let(:params){
            {
              :package_manage => false,
            }
          }

          it { is_expected.to_not contain_package('partekflow') }
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
