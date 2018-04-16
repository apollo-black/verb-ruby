require 'rubygems'
require 'net/http'
require 'json'
require 'uri'
require 'rest_client'

module Verb
  def self.configure(api_key = nil, debug = false)
    pieces = api_key.split('-')

    raise ArgumentError, 'The provided API Token is invalid' if pieces.count != 2

    @api_key = api_key
    @debug = debug
  end

  def self.email(params = {})
    Email.new(@api_key, params, @debug)
  end

  def self.sms(params = {})
    SMS.new(@api_key, params, @debug)
  end

  private

  class Message
    API_URL = ENV['VERB_API'] || 'https://verb.sh/api/v1/message'

    attr_reader :context
    attr_reader :files

    def initialize(params = {}, debug = false)
      @context = {}
      @files = []
      @context[:tags] = []
      @debug = debug
      @api_key = nil

      params.each do |k, v|
        if k != :api_key
          @context[k] = v
        else 
          @context[:pid] = v.split('-').last # We add the project ID to the ctx

          @api_key = v.split('-').first
        end
      end
    end

    # Attach files to the message (if possible)
    def attach(files)
      if @context[:type] == :sms
        raise 'This message type cannot have file attachments'
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

      log(payload)

      begin
        RestClient.post API_URL, payload, {
          'x-api-key': @api_key
        }
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end
    end

    private

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

    # Perform the message logging
    def log(s)
      if @debug
        require 'logger'
        Logger.new(STDOUT).debug(s)
      end
    end
  end

  public

  class Email < Message
    def initialize(api_key, params = {}, debug = false)
      params[:api_key] = api_key
      params[:type] = :email
      super(params, debug)
    end
  end

  class SMS < Message
    def initialize(api_key, params = {}, debug = false)
      params[:api_key] = api_key
      params[:type] = :sms
      super(params, debug)
    end
  end
end
