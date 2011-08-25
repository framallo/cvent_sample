# Cvent
require 'savon'

# Client for the CVent 
#
class Cvent
  attr_accessor :client, :ops

  def initialize(ops={})
    @ops = ops
    @header = {}
    @client = Savon::Client.new do |wsdl, http, wsse|
      http.auth.ssl.verify_mode       = :none
      wsdl.document = @ops['wsdl']
      yield http if block_given?
    end
    login
  end

  def login
    r = @client.request(:login) do |soap| 
      soap.body = { "AccountNumber" => @ops['account_number'], "UserName" => @ops['user_name'], "Password" => @ops['password'] } 
    end
    post_login r.body[:login_response][:login_result]
    return @client
  end

  def post_login login_result
    # fill required headers for future requests
    if login_result[:@login_success] == 'true'
      # set the new url for future requests
      @client.wsdl.document = login_result[:@server_url]
      @header = { "CventSessionHeader"=> login_result[:@cvent_session_header]}
    end
  end

  def soap_actions
    client.wsdl.soap_actions
  end

  def get_updated
    @client.request(:get_updated, @header) do |soap|
      soap.header = @header
    end
  end

  def describe_global
    @client.soap.header = @header
    @client.request(:describe_global) do |soap|
    end
  end

end
