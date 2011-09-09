# Cvent
require 'savon'

# Client for the CVent 
#
class Cvent
  attr_accessor :client, :ops

  TYPES = ["Budget", "BudgetItem", "Contact", "ContactGroup", "Event", "EventDetail", "EventEmailHistory", "EventQuestion", "Invitee", "MeetingRequest", "MeetingRequestUser", "Proposal", "RateHistory", "Registration", "Respondent", "Response", "RFP", "Supplier", "SupplierProposal", "SupplierRFP", "Survey", "SurveyAnswer", "SurveyEmailHistory", "Transaction", "Travel", "User", "UserGroup", "UserRole"]

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
      Savon.env_namespace = :soap
      Savon.soap_header = { 
        "CventSessionHeader"=> { "CventSessionValue"=> login_result[:@cvent_session_header] },
        :attributes! => { "CventSessionHeader"=> { :xmlns=> "http://api.cvent.com/2006-11"} }
      }
    end

  end

  def soap_actions
    client.wsdl.soap_actions
  end

  def get_updated
    @client.request(:get_updated, @header) do |soap|
    end
  end

  def describe_global
    r= @client.request(:describe_global) { |soap| }
  end

  def retrieve(object_type, ids)
    #ids = [ids] unless ids.is_a? Array
    #hids = {}
    validate_object_type object_type

    r= @client.request(:retrieve, "xmlns"=> "http://api.cvent.com/2006-11") do |soap, wsdl, http, wsse| 
      soap.element_form_default = :unqualified
      soap.input = [:Retrieve, {"xmlns"=>"http://api.cvent.com/2006-11"}]
      soap.body = %{
          <ObjectType>#{object_type}</ObjectType>
          <Ids xmlns="http://schemas.cvent.com/api/2006-11">
            <Id>#{ids}</Id>
          </Ids>
      }

    end
    r.to_hash[:retrieve_response][:retrieve_result][:cv_object]
  end

  def get_updated(object_type, start_date, end_date)
    #ids = [ids] unless ids.is_a? Array
    #hids = {}
    validate_object_type object_type

    r= @client.request(:wsdl, :get_updated, :xmlns=> "http://api.cvent.com/2006-11") do |soap| 
      soap.body = { "ObjectType"=> object_type, "StartDate" => start_date, "EndDate" => end_date }
    end
    
  end

  private
  def validate_object_type(type)
    raise InvalidObjectType unless TYPES.include?(type)
  end
end
