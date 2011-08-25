require 'test_helper'
require 'ruby-debug'

ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'
 
class CventTest < Test::Unit::TestCase
  def setup
    @config = YAML::load_file(File.dirname(__FILE__) + '/cvent.yml')[ENV['RAILS_ENV']]
  end

  def teardown
  end

  def test_config
    assert_nothing_raised do
      @client = Cvent.new(@config)
    end
  end

  def test_available_login_action
    @client = Cvent.new(@config)
    assert @client.soap_actions.include?(:login), "CVent API allows login"
  end

  def test_login
    assert_nothing_raised do
      @client = Cvent.new(@config)
    end
  end

  def test_describe_global
    assert_nothing_raised do
      @client = Cvent.new(@config)
      @client.describe_global
    end

  end

  #def test_debug
    #@client = Cvent.new(@config)
    #debugger
    #a = 'a'
  #end

end
