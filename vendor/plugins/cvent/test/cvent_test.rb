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

  #def test_login
    #assert_nothing_raised do
      #@client = Cvent.new(@config)
      #puts @client.login
    #end
  #end

  def test_debug
    @client = Cvent.new(@config)
    puts @client.client.wsdl.inspect
    puts @client.client.http.inspect
    debugger
    a = 'a'
  end
end
