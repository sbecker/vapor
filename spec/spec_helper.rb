# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # Include ActiveMatchers plugin
  config.include ActiveMatchers::Matchers

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  # 
  # For more information take a look at Spec::Example::Configuration and Spec::Runner
end

# Restful Authentication Test Helper
include AuthenticatedTestHelper

include NamedScopeSpecHelper

def stub_logged_in
  @controller.stub!(:login_required).and_return(true)
  @current_user = mock_model(User, :account => mock_model(Account))
  @controller.stub!(:current_user).and_return(@current_user)
  @current_account = @current_user.account
end

def stub_account_with_ec2
  @ec2 = RightAws::Ec2.new("not a secret", "not a key")

  @account = Account.new
  @account.id = 1
  @account.aws_account_number = "AAAATLBUXIEON5NQVUUX6OMPWBZIAAAA"
  @account.stub!(:ec2).and_return(@ec2)
end

def puts_response_body
  puts response.body.gsub(/</, '&lt;').gsub(/\n/, '<br />')
end

module Spec
  module Mocks
    module Methods

      def stub_method_chain(scope_string, value)
        scope_chain = scope_string.split('.')
        method_name = scope_chain.first

        if scope_chain.length > 1
          scope_mock = Spec::Mocks::Mock.new(method_name, {})
          scope_mock.stub_method_chain(scope_chain[1..scope_chain.length].join('.'), value)
        else
          scope_mock = value
        end

        self.stub!(method_name).and_return(scope_mock)
      end

    end
  end
end
