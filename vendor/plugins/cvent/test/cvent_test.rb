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
    @client = Cvent.new(@config)
    describe_global = @client.describe_global.body[:describe_global_response][:describe_global_result]
    describe_global_keys = describe_global.keys

    assert describe_global[:cv_object_types] == Cvent::TYPES
    assert describe_global_keys.include?(:cv_object_types)
    assert describe_global_keys.include?(:@max_api_calls)
    assert describe_global_keys.include?(:@current_api_calls)
    assert describe_global_keys.include?(:@max_batch_size)
    assert describe_global_keys.include?(:@max_record_set)
    assert describe_global_keys.include?(:@xmlns)
  end

  def test_retrieve
      @client = Cvent.new(@config)
      #debugger
      r= @client.retrieve("Event",'A63FE205-7FAB-4374-8393-9F0DDD765DBD')
      r.to_hash.inspect
  end

  def test_get_updated
      @client = Cvent.new(@config)
      r= @client.get_updated("Event",DateTime.now.prev_year.new_offset,DateTime.now.new_offset)
      r.to_hash.inspect
  end

  #def test_debug
    #@client = Cvent.new(@config)
    #debugger
    #a = 'a'
  #end

end
