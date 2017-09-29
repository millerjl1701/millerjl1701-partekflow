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

    describe package('partekflow') do
      it { should be_installed }
    end

    describe service('partekflowd') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
