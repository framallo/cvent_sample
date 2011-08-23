# Cvent
require 'savon'

# Client for the CVent 
#
class Cvent
  attr_accessor :client, :ops

  def initialize(ops={})
    @ops = ops
    @client = Savon::Client.new do |wsdl, http, wsse|
      http.auth.ssl.verify_mode       = :none
      wsdl.document = @ops['wsdl']
      yield http if block_given?
    end
  end

  def login
    @client.request(:login) do |soap| 
      soap.body = { account_number: @ops['account_number'], user_name: @ops['user_name'], password: @ops['password'] } 
    end
  end

  def soap_actions
    client.wsdl.soap_actions
  end

end
