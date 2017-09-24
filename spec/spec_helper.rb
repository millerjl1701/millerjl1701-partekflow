require 'puppetlabs_spec_helper/module_spec_helper'

require 'simplecov'
require 'simplecov-console'

SimpleCov.start do
  add_filter '/spec'
  add_filter '/vendor'
  add_filter '/.vendor'
  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console
  ])
end

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  RSpec.configure do |c|
    c.before :each do
      Puppet.settings[:strict] = :error
    end
  end
end

# put local configuration and setup into spec_helper_local
begin
  require 'spec_helper_local'
rescue LoadError
end
