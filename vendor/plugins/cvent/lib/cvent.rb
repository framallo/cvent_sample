# Cvent
require 'savon'

# Client for the CVent 
#
class Cvent

  def initialize(ops={})
    @ops = ops
    @client = Savon::Client.new do |wsdl, http, wsse|
      wsdl.document = @ops[:wsdl]
      yield http if block_given?
    end
  end

  def login
    @client.request(:wsdl, :login) do |soap| 
      soap.body = { username: @ops[:login], password: @ops[:password] } 
    end
  end

  def client
    @client 
  end
    
end
