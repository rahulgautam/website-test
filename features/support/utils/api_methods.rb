module APIMethods
  require 'httpclient'
  require 'multi_json'
  require 'blinkbox/user'
  require_rel 'utilities.rb'

  class Browserstack
    attr_accessor :username
    attr_accessor :key
    attr_accessor :browsers_uri

    def initialize(username, key)
      @username = username
      @key = key
      @browsers_uri = 'https://www.browserstack.com/automate/browsers.json'
      @plan_uri = 'https://www.browserstack.com/automate/plan.json'
      @projects_uri = 'https://www.browserstack.com/automate/projects.json'
    end

    def valid_capabilities?(browser, browser_version, os, os_version)
      !browser_list.select { |b|
        b['browser'] =~ /#{browser}/i &&
        b['browser_version'] =~ /#{browser_version}/i &&
        b['os'] =~ /#{os}/i &&
        b['os_version'] =~ /#{os_version}/i
      }.empty?
    end

    def session_available?
      response = plan_status
      response['parallel_sessions_running'] < response['parallel_sessions_max_allowed']
    end

    def project_exists?(project_name)
      !!project_list.find { |entry| entry['automation_project']['name'] == project_name }
    end

    def http_client
      @http = HTTPClient.new
    end

    def browserstack_api_helper(username, key)
      APIMethods::Browserstack.new(username, key)
    end

    private

    def browser_list
      headers = { 'Authorization' => Base64.strict_encode64("#{@username}:#{@key}"),
                  'Content-Type' => 'application/x-www-form-urlencoded',
                  'Accept' => 'application/json' }
      response = http_client.get(@browsers_uri, body: {}, header: headers)
      fail 'Test Error: Failed to get browsers list from BrowserStack!' unless response.status == 200
      MultiJson.load(response.body)
    end

    def plan_status
      headers = { 'Authorization' => Base64.strict_encode64("#{@username}:#{@key}"),
                  'Content-Type' => 'application/x-www-form-urlencoded',
                  'Accept' => 'application/json' }
      response = http_client.get(@plan_uri, body: {}, header: headers)
      fail 'Test Error: Failed to get number of free sessions from BrowserStack!' unless response.status == 200
      MultiJson.load(response.body)
    end

    def project_list
      headers = { 'Authorization' => Base64.strict_encode64("#{@username}:#{@key}"),
                  'Content-Type' => 'application/x-www-form-urlencoded',
                  'Accept' => 'application/json' }
      response = http_client.get(@projects_uri, body: {}, header: headers)
      fail 'Test Error: Failed to get list of projects from BrowserStack!' unless response.status == 200
      MultiJson.load(response.body)
    end
  end

  class User
    include Utilities

    def initialize(auth, api, braintree_env)
      @auth_uri = auth
      @api_uri = api
      @braintree_env = braintree_env
    end

    def create_new_user!(options = {})
      @email_address = options[:email_address] || generate_random_email_address
      @password = options[:password] || 'test1234'
      client = {}

      if options[:with_client]
        @device_name = options[:client_name] || 'Web Site Test Client'
        @device_brand = options[:client_brand] || 'Tesco'
        @device_model = options[:client_model] || 'Hudl'
        @device_os = options[:client_os] || 'Android'
        client = { client_name: @device_name, client_brand: @device_brand, client_model: @device_model, client_os: @device_os }
      end

      @user = Blinkbox::User.new(username: @email_address, password: @password, server_uri: @auth_uri, credit_card_service_uri: @api_uri)
      response = @user.register(client)
      response.merge!({ 'password' => @password, 'device_name' => @device_name })
    end

    def add_credit_card(options = {})
      create_new_user! if @user.nil?
      @card_type = options[:card_type] || 'visa'

      @user.authenticate
      @user.add_default_credit_card(card_type: @card_type, braintree_env: @braintree_env)
    end
  end

  def api_helper
    @api_helper ||= APIMethods::User.new(server('auth'), server('api'), server('braintree_env'))
  end
end
World(APIMethods)
