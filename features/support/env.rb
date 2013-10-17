$: << "."
$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), ".."))

require 'selenium-webdriver'
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'site_prism'
require 'active_support/core_ext'
require 'rspec/expectations'

World(RSpec::Matchers)

require 'support/formatters/html_custom_formatter'

TEST_CONFIG = ENV.to_hash || {}
TEST_CONFIG["debug"] = !!(TEST_CONFIG["DEBUG"] =~ /^on|true$/i)
puts "TEST_CONFIG: #{TEST_CONFIG}" if TEST_CONFIG["debug"]

Capybara.default_driver = :selenium
Capybara.default_wait_time = 5

#overriding the default native events settings for Selenium.
#This is to make mouse over action working. Without this setting mouse over actions (to activate my account drop down, etc) are not working.
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app,
                                 :desired_capabilities => {:native_events => false})
end

ARGV.each do |a|
  puts "Argument: #{a}"
end

#TODO: move into config/environments.yml once more environments are added
# target environment
environments = {
    'NODEJS-INTERNAL' => 'https://nodejs-internal.mobcastdev.com',
    'QA' => 'https://qa.mobcastdev.com',
    'STAGING' => nil,
    'PRODUCTION' => 'https://blinkboxbooks.com'
}
TEST_CONFIG['SERVER'] ||= 'QA'
raise "Environment is not supported: #{TEST_CONFIG['SERVER']}" if environments[TEST_CONFIG['SERVER'].upcase].nil?
Capybara.app_host = environments[TEST_CONFIG['SERVER'].upcase]

# grid setup
if TEST_CONFIG['GRID'] =~ /^true|on$/i

  # target browser
  TEST_CONFIG['BROWSER_NAME'] ||= 'firefox'
  TEST_CONFIG['BROWSER_NAME'] = 'ie' if TEST_CONFIG['BROWSER_NAME'].downcase == 'internet explorer'
  caps = case TEST_CONFIG['BROWSER_NAME'].downcase
    when 'firefox', 'safari', 'ie', 'chrome'
      Selenium::WebDriver::Remote::Capabilities.send(TEST_CONFIG['BROWSER_NAME'].downcase.to_sym)
    when 'htmlunit'
      Selenium::WebDriver::Remote::Capabilities.htmlunit(:javascript_enabled => true)
    else
      raise "Not supported browser: #{TEST_CONFIG['BROWSER_NAME']}"
  end

  # target platform
  TEST_CONFIG['PLATFORM'] ||= 'MAC'
  caps.platform = case TEST_CONFIG['PLATFORM'].upcase
    when 'MAC', 'XP', 'VISTA', 'WIN8', 'WINDOWS' # *WINDOWS* stands for Windows 7
      TEST_CONFIG['PLATFORM'].upcase.to_sym
    else
      raise "Not supported platform: #{TEST_CONFIG['PLATFORM']}"
  end

  caps.version = TEST_CONFIG['BROWSER_VERSION']
  # Overriding the default native events settings for Selenium.
  # This is to make mouse over action working. Without this setting mouse over actions (to activate my account drop down, etc) are not working.
  caps.native_events=false

  # register the remote driver
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app,
                                   :browser => :remote,
                                   :url => "http://selenium.mobcastdev.local:4444/wd/hub",
                                   :desired_capabilities => caps)
  end
end

#Capybara.default_wait_time = 10