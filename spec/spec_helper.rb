# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

module Warden
  # Warden::Test::ControllerHelpers provides a facility to test controllers in isolation
  # Most of the code was extracted from Devise's Devise::TestHelpers.
  module Test
    module ControllerHelpers
      def self.included(base)
        base.class_eval do
          setup :setup_controller_for_warden, :warden if respond_to?(:setup)
        end
      end

      # Override process to consider warden.
      def process(*)
        # Make sure we always return @response, a la ActionController::TestCase::Behavior#process, even if warden interrupts
        _catch_warden {super} || @response
      end

      # We need to setup the environment variables and the response in the controller
      def setup_controller_for_warden
        @request.env['action_controller.instance'] = @controller
      end

      # Quick access to Warden::Proxy.
      def warden
        @warden ||= begin
          manager = Warden::Manager.new(nil, &Rails.application.config.middleware.detect{|m| m.name == 'Warden::Manager'}.block)
          @request.env['warden'] = Warden::Proxy.new(@request.env, manager)
        end
      end

      protected

      # Catch warden continuations and handle like the middleware would.
      # Returns nil when interrupted, otherwise the normal result of the block.
      def _catch_warden(&block)
        result = catch(:warden, &block)

        if result.is_a?(Hash) && !warden.custom_failure? && !@controller.send(:performed?)
          result[:action] ||= :unauthenticated

          env = @controller.request.env
          env['PATH_INFO'] = "/#{result[:action]}"
          env['warden.options'] = result
          Warden::Manager._run_callbacks(:before_failure, env, result)

          status, headers, body = warden.config[:failure_app].call(env).to_a
          @controller.send :render, :status => status, :text => body,
            :content_type => headers['Content-Type'], :location => headers['Location']

          nil
        else
          result
        end
      end
    end
  end
end

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  config.include Warden::Test::ControllerHelpers, type: :controller
end
