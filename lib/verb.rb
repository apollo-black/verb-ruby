require 'rubygems'
require 'net/http'
require 'json'
require 'uri'
require 'rest_client'

module Verb
  def self.configure(api_key = nil)
    tokens = api_key.split('-')

    raise ArgumentError, 'API Token is invalid' if tokens.count != 3

    @api_key = api_key
  end

  def self.email(params = {})
    Email.new(@api_key, params)
  end

  def self.sms(params = {})
    SMS.new(@api_key, params)
  end

  private

  class Message
    API_URL = ENV['VERB_API'] || ''https://verb.sh/api/v1/message'

    attr_reader :context
    attr_reader :files

    def initialize(params = {})
      @context = {}
      @files = []
      @context[:tags] = []

      params.each do |k, v|
        @context[k] = v
      end
    end

    # Attach files to the message
    def attach(files)
      if @context[:type] != :email
        raise "This message type cannot have file attachments"
      end

      parsed_files(files).each do |f|
        @files << f
      end
    end

    # Add tags to the internal tag array
    def tag(tags)
      if tags.is_a? Array
        tags.each do |t|
          @context[:tags] << t
        end
      else
        @context[:tags] << tags
      end
    end

    # Send the message to the Verb API
    def send(args = {})
      payload = {
        files: []
      }

      payload.merge!(args)
      payload.merge!(@context)

      # Attach Files

      @files.each_with_index do |f, idx|
        payload[:files] << File.open(f)
      end

      @response = post(payload)
    end

    private

    # @TODO: Improve error response handling and feedback
    def post(payload = {})
      begin
        RestClient.post API_URL, payload
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end
    end

    # Parse the files and return an array of files that exist
    def parsed_files(files)
      buffer = []

      if files.kind_of?(Array)
        files.each do |f|
          buffer << canonical_path(f)
        end
      else
        buffer << canonical_path(files)
      end

      buffer.compact
    end

    # Ensure that we get the path to the file instead of the File objects
    def canonical_path(f)
      buffer = nil

      if f.kind_of?(String)
        if File.exist?(f)
          buffer = f
        end
      end

      if f.kind_of?(File)
        buffer = f.path
      end

      buffer
    end
  end

  public

  class Email < Message
    def initialize(api_key, params = {})
      params[:api_key] = api_key
      params[:type] = :email
      super(params)
    end
  end

  class SMS < Message
    def initialize(api_key, params = {})
      params[:api_key] = api_key
      params[:type] = :sms
      super(params)
    end
  end
end
