require 'spec_helper_acceptance'

describe 'partekflow class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'partekflow': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe group('flowuser') do
      it { should exist }
      it { should have_gid 499 }
    end

    describe user('flow') do
      it { should exist }
      it { should have_uid 499 }
      it { should belong_to_primary_group 'flowuser' }
      it { should have_home_directory '/home/flow' }
      it { should have_login_shell '/bin/sh' }
    end

    describe file('/etc/pki/rpm-gpg/partek-public.key') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      its(:md5sum) { should eq 'c3cfb0039826913eec0a8201c7ce1ccb' }
    end

    describe package('partekflow') do
      it { should be_installed }
    end

    describe file('/etc/partekflow.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      it { should contain 'FLOWuser=flow' }
      it { should contain 'FLOWhome=/home/flow' }
      it { should contain 'FLOWbase=/opt/partek_flow' }
      it { should contain 'HTTP_PORT=8080' }
      it { should contain 'HTTPS_PORT=10443' }
      it { should contain 'SHUTDOWN_PORT=8015' }
      it { should contain 'AJP_PORT=8009' }
      it { should contain 'logfil="$FLOWbase"/logs/daemon.log' }
    end

    describe file('/opt/partek_flow/temp') do
      it { should be_directory }
      it { should be_owned_by 'flow' }
      it { should be_grouped_into 'flowuser' }
      it { should be_mode 755 }
    end

    describe service('partekflowd') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
