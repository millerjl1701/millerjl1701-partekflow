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

          it { is_expected.to contain_class('partekflow') }
          it { is_expected.to contain_class('partekflow::install').that_comes_before('Class[partekflow::config]') }
          it { is_expected.to contain_class('partekflow::config') }
          it { is_expected.to contain_class('partekflow::service').that_subscribes_to('Class[partekflow::config]') }

          it { is_expected.to contain_package('partekflow').with_ensure('present') }

          it { is_expected.to contain_service('partekflowd') }
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
