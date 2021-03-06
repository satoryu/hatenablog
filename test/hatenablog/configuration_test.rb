require 'test_helper'

require 'hatenablog/configuration'

module Hatenablog
  class ConfigurationTest < Test::Unit::TestCase
    sub_test_case 'correct configuration with OAuth configuration file' do
      setup do
        @sut = Hatenablog::Configuration.create('test/fixture/test_conf.yml')
      end

      test 'consumer key' do
        assert_equal 'cMOVPffXo7LiL317UeaiEQ==', @sut.consumer_key
      end

      test 'consumer secret' do
        assert_equal '0987654321ZYXWVUTSRQPONML=', @sut.consumer_secret
      end

      test 'access token' do
        assert_equal 'oGoYArVaBWpNSKp9ljXm+g==', @sut.access_token
      end

      test 'access token secret' do
        assert_equal '7OgCvJW/GPbFnAnIHgG2t1ivdzxrvZTdvJl/yA==', @sut.access_token_secret
      end

      test 'user ID' do
        assert_equal 'test_user', @sut.user_id
      end

      test 'blog ID' do
        assert_equal 'test-user.hatenablog.com', @sut.blog_id
      end

      test 'valid configuration' do
        assert_equal @sut, @sut.check_valid_or_raise
      end
    end

    sub_test_case 'correct configuration with Basic configuration file' do
      setup do
        @sut = Hatenablog::Configuration.create('test/fixture/test_conf_basic.yml')
      end

      test 'API key' do
        assert_equal 'sukw9e87fg', @sut.api_key
      end

      test 'user ID' do
        assert_equal 'test_user', @sut.user_id
      end

      test 'blog ID' do
        assert_equal 'test-user.hatenablog.com', @sut.blog_id
      end

      test 'auth type' do
        assert_equal 'basic', @sut.auth_type
      end

      test 'valid configuration' do
        assert_equal @sut, @sut.check_valid_or_raise
      end
    end

    sub_test_case 'incorrect configuration' do
      test 'raise error when reading incorrect configuration' do
        assert_raise(Hatenablog::ConfigurationError.new('Following keys are not setup. ["access_token"]')) do
          Hatenablog::Configuration.create('test/fixture/error_conf.yml')
        end
      end
    end
  end
end
