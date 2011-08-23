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
      soap.body = { "AccountNumber" => @ops['account_number'], "UserName" => @ops['user_name'], "Password" => @ops['password'] } 
    end
  end

  def soap_actions
    client.wsdl.soap_actions
  end

end
