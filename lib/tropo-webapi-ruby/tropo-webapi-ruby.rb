# @author Jason Goecke
module Tropo
  class Generator 
    include Tropo::Helpers
    
    ##
    # Set a couple of Booleans to indicate the session type as a convenience 
    # Set a default voice for speech synthesis
    # Set a default recognizer for speech recognition
    attr_reader :voice_session, :text_session, :voice, :recognizer
    
    ##
    # Defines the actions on self so that we may call them individually
    #
    # @return [nil]
    class << self
      def method_missing(method_id, *args, &block)
        g = Generator.new
        g.send(method_id, *args, &block)
      end
    end
    
    ##
    # Initializes the Generator class
    #
    # @overload initialize()
    # @overload initialize(params)
    #   @param [String] voice sets the value of the default voice
    #   @param [Object] pass in an object that may be accessed inside the block
    # @overload initialize(params, &block)
    #   @param [Object] pass in an object that may be accessed inside the block
    #   @param [String] voice sets the value of the default voice
    #   @param [Block] a block of code to execute (optional)
    # @return [Object] a new Generator object
    def initialize(params={}, &block)
      @response = { :tropo => Array.new }
      @voice = params[:voice] if params[:voice]
      @recognizer = params[:recognizer] if params[:recognizer]
      
      if block_given?
        # Lets us know were are in the midst of building a block, so we only rendor the JSON
        # response at the end of executing the block, rather than at each action
        @building = true
        instance_exec(&block)
        render_response
      end
    end
    
    ##
    # Prompts the user (audio file or text to speech) and optionally waits for a response from the user. 
    # If collected, responses may be in the form of DTMF, speech recognition or text using a grammar or 
    # free-form text.
    #
    # @overload ask(params)
    #   @param [Hash] params the options to create an ask action request with.
    #   @option params [required, String] :choices indicates the structure of the expected data and acceptable modes of input - value, mode, terminator
    #   @option params [optional, String] :say determines what is played or sent to the caller - also takes an event key to determine if prompt will be played based on a nomatch or timeout
    #   @option params [optional, String or Array] :allow_signals allows you to assign a signal to ask which can be used with REST to interrupt the function 
    #   @option params [optional, String] :name this is the key used to identify the result of an operation, so you can differentiate between multiple results
    #   @option params [optional, Integer] :attempts (1) the number of times to prompt the user for input
    #   @option params [optional, Boolean] :bargein (true) allows a user to say or enter a key to stop the prompt from playing further
    #   @option params [optional, Integer] :interdigit_timeout (nil) defines how long to wait between key presses to determine the user has stopped entering input
    #   @option params [optional, Integer] :min_confidence (30) the minimum confidence by which to accept the response, as opposed to asking again
    #   @option params [optional, Boolean] :required (true) determines whether Tropo should move on to the next verb - if true, Tropo will only move on if the current operation completed
    #   @option params [optional, Integer] :timeout (30) the amount of time, in seconds, to wait for a response before moving on
    #   @option params [optional, String] :recognizer this tells Tropo what language to listen for
    #   @option params [optional, String] :voice (allison) specifies the voice to be used when speaking text to a user
    # @overload ask(params, &block)
    #   @param [Hash] params the options to create an ask action request with.
    #   @param [Block] takes a block so that you may trigger actions, such as a say, on a specific event
    #   @option params [required, String] :choices indicates the structure of the expected data and acceptable modes of input - value, mode, terminator
    #   @option params [optional, String] :say determines what is played or sent to the caller - also takes an event key to determine if prompt will be played based on a nomatch or timeout
    #   @option params [optional, String or Array] :allow_signals allows you to assign a signal to ask which can be used with REST to interrupt the function
    #   @option params [optional, String] :name this is the key used to identify the result of an operation, so you can differentiate between multiple results
    #   @option params [optional, Integer] :attempts (1) the number of times to prompt the user for input
    #   @option params [optional, Boolean] :bargein (true) allows a user to say or enter a key to stop the prompt from playing further
    #   @option params [optional, Integer] :interdigit_timeout (nil) defines how long to wait between key presses to determine the user has stopped entering input
    #   @option params [optional, Integer] :min_confidence (30) the minimum confidence by which to accept the response, as opposed to asking again
    #   @option params [optional, Boolean] :required (true) determines whether Tropo should move on to the next verb - if true, Tropo will only move on if the current operation completed
    #   @option params [optional, Integer] :timeout (30) the amount of time, in seconds, to wait for a response before moving on
    #   @option params [optional, String] :recognizer this tells Tropo what language to listen for
    #   @option params [optional, String] :voice (allison) specifies the voice to be used when speaking text to a user
    # @return [String, nil] the JSON string to be passed back to Tropo or nil
    #   if the method has been called from inside a block
    def ask(params={}, &block)
      params = set_language(params)
      if block_given?
        create_nested_hash('ask', params)
        instance_exec(&block)
        @response[:tropo] << @nested_hash
      else
        hash = build_action('ask', params)
        @response[:tropo] << hash
      end
      render_response if @building.nil?
    end
    alias :prompt :ask
    
    ##
    # Prompts initiates a new call. May only be used when no call is active.
    #
    # @overload call(params)
    #   @param [Hash] params the options to create a call action request with.
    #   @option params [optional, String] :name this is the key used to identify the result of an operation, so you can differentiate between multiple results
    #   @option params [String] :to the destination of the call, may be a phone number, SMS number or IM address
    #   @option params [optional, String] :from the phone number or IM address the call will come from
    #   @option params [optional, String] :network which network the call will be initiated with, such as SMS
    #   @option params [optional, String] :channel the channel the call will be initiated over, may be TEXT or VOICE
    #   @option params [optional, Integer] :timeout (30) the amount of time, in seconds, to wait for a response before moving on
    #   @option params [optional, Boolean] :answer_on_media (false) if true, the call will be concisdered answered and audio will being playing as soon as media is received (ringing, busy, etc)
    #   @options params [optional, Hash] :headers A set of key/values to apply as customer SIP headers to the outgoing call
    #   @options params [optional, Hash] :recording allow you to start call recording as soon as the call is answered; refer to the recording method for paramaters in the hash
    #   @option params [optional, Boolean] :required (true) determines whether Tropo should move on to the next verb - if true, Tropo will only move on if the current operation completed
    #   @option params [optional, String or Array] :allow_signals allows you to assign a signal to call which can be used with REST to interrupt the function 
    # @overload call(params, &block)
    #   @param [Hash] params the options to create an message action request with.
    #   @param [Block] takes a block so that you may trigger actions, such as a say, on a specific event
    #   @option params [optional, String] :name this is the key used to identify the result of an operation, so you can differentiate between multiple results
    #   @option params [String] :to the destination of the call, may be a phone number, SMS number or IM address
    #   @option params [optional, String] :from the phone number or IM address the call will come from
    #   @option params [optional, String] :network which network the call will be initiated with, such as SMS
    #   @option params [optional, String] :channel (voice) the channel the call will be initiated over, may be TEXT or VOICE
    #   @option params [optional, Integer] :timeout (30) the amount of time, in seconds, to wait for a response before moving on
    #   @option params [optional, Boolean] :answer_on_media (false) if true, the call will be concisdered answered and audio will being playing as soon as media is received (ringing, busy, etc)
    #   @options params [optional, Hash] :headers A set of key/values to apply as customer SIP headers to the outgoing call
    #   @options params [optional, Hash] :recording allow you to start call recording as soon as the call is answered; refer to the recording method for paramaters in the hash
    #   @option params [optional, Boolean] :required (true) determines whether Tropo should move on to the next verb - if true, Tropo will only move on if the current operation completed
    #   @option params [optional, String or Array] :allow_signals allows you to assign a signal to call which can be used with REST to interrupt the function 
    # @return [String, nil] the JSON string to be passed back to Tropo or nil
    #   if the method has been called from inside a block
    def call(params={}, &block)
      if block_given?
        create_nested_hash('call', params)
        instance_exec(&block)
        @response[:tropo] << @nested_hash
      else
        hash = build_action('call', params)
        @response[:tropo] << hash
      end
      render_response if @building.nil?
    end
    
    ##
    # Choices to give the user on input
    #
    # @param [Hash] params the options used to construct the grammar for the user
    # @option params [String] :value this is the grammar which determines the type of expected data, such as [DIGITS]
    # @option params [optional, String] :mode (ANY) the mode to use when asking the user [DTMF, SPEECH or ANY]
    # @option params [optional, String] :terminator (#) the user may enter a keypad entry to stop the request
    # @option [String, nil] the JSON string to be passed back to Tropo or nil
    #   if the method has been called from inside a block
    def choices(params={})
      hash = build_action('choices', params)
      
      if @nested_hash
        @nested_hash[@nested_name.to_sym].merge!(hash)
      else
        @response[:tropo] << hash
        render_response if @building.nil?
      end
    end
    
    ##
    # Creates a conference or pushes a user to an existing conference
    #
    # @overload conference(params)
    #   @param [Hash] params the options to create a message with.
    #   @option params [optional, String] :name this is the key used to identify the result of an operation, so you can differentiate between multiple results
    #   @option params [required, Integer] :id the number to assign to the conference room
    #   @option params [optional, Integer] :interdigit_timeout (nil) defines how long to wait between key presses to determine the user has stopped entering input
    #   @option params [optional, Boolean] :mute (false) whether to mute this caller in the conference
    #   @option params [optional, Integer] :play_tones whether to allow the DTMF input from a user to play into the conference
    #   @option params [optional, String] :terminator this is the touch-tone key (DTMF) used to exit the conference
    #   @option params [optional, Boolean] :required (true) determines whether Tropo should move on to the next verb - if true, Tropo will only move on if the current operation completed
    #   @option params [optional, String or Array] :allow_signals allows you to assign a signal to conference which can be used with REST to interrupt the function 
    # @overload conference(params, &block)
    #   @param [Hash] params the options to create a message with.
    #   @param [Block] takes a block so that you may trigger actions, such as a say, on a specific event
    #   @option params [optional, String] :name this is the key used to identify the result of an operation, so you can differentiate between multiple results
    #   @option params [Integer] :id the number to assign to the conference room
    #   @option params [optional, Integer] :interdigit_timeout (nil) defines how long to wait between key presses to determine the user has stopped entering input
    #   @option params [optional, Boolean] :mute (false) whether to mute this caller in the conference
    #   @option params [optional, Integer] :play_tones whether to allow the DTMF input from a user to play into the conference
    #   @option params [optional, String] :terminator this is the touch-tone key (DTMF) used to exit the conference
    #   @option params [optional, Boolean] :required (true) determines whether Tropo should move on to the next verb - if true, Tropo will only move on if the current operation completed
    #   @option params [optional, String or Array] :allow_signals allows you to assign a signal to conference which can be used with REST to interrupt the function 
    # @return [String, nil] the JSON string to be passed back to Tropo or nil
    #   if the method has been called from inside a block
    def conference(params={}, &block)
      if block_given?
        create_nested_hash('conference', params)
        instance_exec(&block)
        @response[:tropo] << @nested_hash
      else
        hash = build_action('conference', params)
        @response[:tropo] << hash
      end
      render_response if @building.nil?
    end
    
    ##
    # This function instructs Tropo to "hang-up" or disconnect the current session.
    #
    # May trigger these events:
    #   - hangup
    #   - error
    # @overload hangup(params)
    #   @param [Hash] params the options to create a message action request with.
    #   @option params [String] :headers contains the Session Initiation Protocol (SIP) Headers for the current session.
    # @overload hangup(params, &block)
    #   @param [Hash] params the options to create an message action request with.
    #   @param [Block] takes a block so that you may trigger actions, such as a say, on a specific event
    #   @option params [String] :headers contains the Session Initiation Protocol (SIP) Headers for the current session.
    # @return [String, nil] returns the JSON string to hangup/stop the current session or nil
    #   if the method has been called from inside a block
    def hangup
      @response[:tropo] << { :hangup => nil }
      render_response if @building.nil? 
    end
    alias :disconnect :hangup
    
    ##
    # Message initiates a new message to a destination and then hangs up on that destination. Also takes a say method
    # in order to deliver a message to that desintation and then hangup.
    #
    # @overload message(params)
    #   @param [Hash] params the options to create a message action request with.
    #   @option params [optional, String] :name this is the key used to identify the result of an operation, so you can differentiate between multiple results
    #   @option params [required, String] :say determines what is played or sent to the caller
    #   @option params [optional, String] :voice (allison) specifies the voice to be used when speaking text to a user
    #   @option params [required, String] :to the destination of the call, may be a phone number, SMS number or IM address
    #   @option params [optional, String] :from the phone number or IM address the call will come from
    #   @option params [optional, String] :network which network the call will be initiated with, such as SMS
    #   @option params [optional, String] :channel the channel the call will be initiated over, may be TEXT or VOICE
    #   @option params [optional, Integer] :timeout (30) the amount of time, in seconds, to wait for a response before moving on
    #   @option params [optional, Boolean] :required (true) determines whether Tropo should move on to the next verb - if true, Tropo will only move on if the current operation completed
    #   @option params [optional, Boolean] :answer_on_media (false) if true, the call will be concisdered answered and audio will being playing as soon as media is received (ringing, busy, etc)
    # @overload message(params, &block)
    #   @param [Hash] params the options to create an message action request with.
    #   @param [Block] takes a block so that you may trigger actions, such as a say, on a specific event
    #   @option params [optional, String] :name this is the key used to identify the result of an operation, so you can differentiate between multiple results
    #   @option params [required, String] :say determines what is played or sent to the caller
    #   @option params [optional, String] :voice (allison) specifies the voice to be used when speaking text to a user
    #   @option params [required, String] :to the destination of the call, may be a phone number, SMS number or IM address
    #   @option params [optional, String] :from the phone number or IM address the call will come from
    #   @option params [optional, String] :network which network the call will be initiated with, such as SMS
    #   @option params [optional, String] :channel the channel the call will be initiated over, may be TEXT or VOICE
    #   @option params [optional, Integer] :timeout (30) the amount of time, in seconds, to wait for a response before moving on
    #   @option params [optional, Boolean] :required (true) determines whether Tropo should move on to the next verb - if true, Tropo will only move on if the current operation completed
    #   @option params [optional, Boolean] :answer_on_media (false) if true, the call will be concisdered answered and audio will being playing as soon as media is received (ringing, busy, etc)
    # @return [String, nil] the JSON string to be passed back to Tropo or nil
    #   if the method has been called from inside a block
    def message(params={}, &block)
      if block_given?
        create_nested_hash('message', params)
        instance_exec(&block)
        @response[:tropo] << @nested_hash
      else
        hash = build_action('message', params)
        @response[:tropo] << hash
      end
      render_response if @building.nil?
    end
    
    ##
    # Sets event handlers to call a REST resource when a particular event occurs
    #
    # @overload initialize(params)
    #   @param [Hash] params the options to create a message with.
    #   @option params [required, String] :event the event name that should trigger the callback
    #   @option params [optional, String] :next the resource to send the callback to, such as '/error.json'
    #   @option params [optional, String] :say determines what is played or sent to the caller
    # @overload initialize(params, &block)
    #   @param [Hash] params the options to create a message with.
    #   @param [Block] takes a block so that you may trigger actions, such as a say, on a specific event
    #   @option params [required, String] :event the event name that should trigger the callback
    #   @option params [optional, String] :next the resource to send the callback to, such as '/error.json'
    #   @option params [optional, String] :say determines what is played or sent to the caller
    # @option [String, nil] the JSON string to be passed back to Tropo or nil
    #   if the method has been called from inside a block
    def on(params={}, &block)
      if block_given?
        create_nested_on_hash(params)
        instance_exec(&block)
        if @nested_hash
          @nested_hash[@nested_name.to_sym].merge!(@nested_on_hash)
        end
      else
        create_on_hash
        hash = build_action('on', params)
        @on_hash[:on] << hash
        if @nested_hash
          @nested_hash[@nested_name.to_sym].merge!(@on_hash)
        else
          @response[:tropo] << { :on => hash }
          render_response if @building.nil?
        end
      end
    end

    ##
    # Parses the JSON string recieved from Tropo into a Ruby Hash, or 
    # if already a Ruby Hash parses it with the nicities provided by
    # the gem
    #
    # @param [String or Hash] a JSON string or a Ruby Hash
    # @return [Hash] a Hash representing the formatted response from Tropo
    def parse(response)
      response = JSON.parse(response) if response.class == String

      # Check to see what type of response we are working with
      if response['session']
        transformed_response = { 'session' => { } }
        
        response['session'].each_pair do |key, value|
          value = transform_hash value if value.kind_of? Hash
          transformed_response['session'].merge!(transform_pair(key, value))
        end
        
      elsif response['result']
        transformed_response = { 'result' => { } }

        response['result'].each_pair do |key, value|
          value = transform_hash value if value.kind_of? Hash
          value = transform_array value  if value.kind_of? Array
          transformed_response['result'].merge!(transform_pair(key, value))
        end
      end

      transformed_response = Hashie::Mash.new(transformed_response)
    end
    
    ##
    # Sets the default recognizer for the object
    #
    # @param [String] recognizer the value to set the default voice to
    def recognizer=(recognizer)
      @recognizer = recognizer
    end
    
    ##
    # Plays a prompt (audio file or text to speech) and optionally waits for a response from the caller that is recorded. 
    # If collected, responses may be in the form of DTMF or speech recognition using a simple grammar format defined below. 
    # The record funtion is really an alias of the prompt function, but one which forces the record option to true regardless of how it is (or is not) initially set. 
    # At the conclusion of the recording, the audio file may be automatically sent to an external server via FTP or an HTTP POST/Multipart Form. 
    # If specified, the audio file may also be transcribed and the text returned to you via an email address or HTTP POST/Multipart Form.
    #
    # @overload record(params)
    #   @param [Hash] params the options to create a message with.
    #   @option params [optional, Integer] :attempts (1) the number of times to prompt the user for input
    #   @option params [optional, String or Array] :allow_signals allows you to assign a signal to record which can be used with REST to interrupt the function 
    #   @option params [optional, Boolean] :bargein (true) allows a user to say or enter a key to stop the prompt from playing further
    #   @option params [optional, Boolean] :beep (true) when true, callers will hear a tone indicating the recording has begun
    #   @option params [optional, String] :choices when used with record, this defines the terminator
    #   @option params [required, String] :say determines what is played or sent to the caller
    #   @option params [optional, String] :voice (allison) specifies the voice to be used when speaking text to a user
    #   @option params [optional, String] :format (audio/wav) the audio format to record in, either a wav or mp3
    #   @option params [optional, Float] :max_silence (5.0) the max amount of time in seconds to wait for silence before considering the user finished speaking
    #   @option params [optional, Float] :max_time (30.0) the max amount of time in seconds the user is allotted for input
    #   @option params [optional, String] :method (POST) this defines how to send the audio file, either POST or PUT, and only applies to HTTP
    #   @option params [optional, Integer] :min_confidence (30) the minimum confidence by which to accept the response, as opposed to asking again
    #   @option params [optional, String] :name this is the key used to identify the result of an operation, so you can differentiate between multiple results
    #   @option params [optional, Boolean] :required (true) determines whether Tropo should move on to the next verb - if true, Tropo will only move on if the current operation completed
    #   @option params [optional, Hash] :transcription allows you to submit a recording to be transcribed - takes parameters id, url and emailFormat
    #   @option params [optional, String] :url the destination URL to send the recording, either via FTP or HTTP
    #   @option params [optional, String] :username if posting to FTP, the username for the FTP server
    #   @option params [optional, String] :password if posting to FTP, the password for the FTP server
    #   @option params [optional, Float] :timeout amount of time Tropo will wait--in seconds and after sending or playing the prompt--for the user to begin a response
    #   @option params [optional, Integer] :interdigit_timeout (nil) defines how long to wait between key presses to determine the user has stopped entering input
    # @overload record(params, &block)
    #   @param [Hash] params the options to create a message with.
    #   @param [Block] takes a block so that you may trigger actions, such as a say, on a specific event
    #   @option params [optional, Integer] :attempts (1) the number of times to prompt the user for input
    #   @option params [optional, String or Array] :allow_signals allows you to assign a signal to record which can be used with REST to interrupt the function 
    #   @option params [optional, Boolean] :bargein (true) allows a user to say or enter a key to stop the prompt from playing further
    #   @option params [optional, Boolean] :beep (true) when true, callers will hear a tone indicating the recording has begun
    #   @option params [optional, String] :choices when used with record, this defines the terminator
    #   @option params [required, String] :say determines what is played or sent to the caller
    #   @option params [optional, String] :voice (allison) specifies the voice to be used when speaking text to a user
    #   @option params [optional, String] :format (audio/wav) the audio format to record in, either a wav or mp3
    #   @option params [optional, Float] :max_silence (5.0) the max amount of time in seconds to wait for silence before considering the user finished speaking
    #   @option params [optional, Float] :max_time (30.0) the max amount of time in seconds the user is allotted for input
    #   @option params [optional, String] :method (POST) this defines how to send the audio file, either POST or PUT, and only applies to HTTP
    #   @option params [optional, Integer] :min_confidence (30) the minimum confidence by which to accept the response, as opposed to asking again
    #   @option params [optional, String] :name this is the key used to identify the result of an operation, so you can differentiate between multiple results
    #   @option params [optional, Boolean] :required (true) determines whether Tropo should move on to the next verb - if true, Tropo will only move on if the current operation completed
    #   @option params [optional, Hash] :transcription allows you to submit a recording to be transcribed - takes parameters id, url and emailFormat
    #   @option params [optional, String] :url the destination URL to send the recording, either via FTP or HTTP
    #   @option params [optional, String] :username if posting to FTP, the username for the FTP server
    #   @option params [optional, String] :password if posting to FTP, the password for the FTP server
    #   @option params [optional, Float] :timeout amount of time Tropo will wait--in seconds and after sending or playing the prompt--for the user to begin a response
    #   @option params [optional, Integer] :interdigit_timeout (nil) defines how long to wait between key presses to determine the user has stopped entering input
    # @option [String, nil] the JSON string to be passed back to Tropo or nil
    #   if the method has been called from inside a block
    def record(params={}, &block)
      if block_given?
        create_nested_hash('record', params)
        instance_exec(&block)
        @response[:tropo] << @nested_hash
      else
        hash = build_action('record', params)
        @response[:tropo] << hash
      end
      render_response if @building.nil?
    end
    
    ##
    # The redirect function forwards an incoming SIP call to another destination before answering it. 
    # The redirect function must be called before answer is called; redirect expects that a call be in the ringing or answering state. 
    # Use transfer when working with active answered calls.
    #
    #
    # @param [Hash] params the options to create a message with.
    #   @option params [optional, String] :name this is the key used to identify the result of an operation, so you can differentiate between multiple results
    #   @option params [optional, Boolean] :required (true) determines whether Tropo should move on to the next verb - if true, Tropo will only move on if the current operation completed
    #   @option params [required, String] :to where to redirect the session to
    # @return [String, nil] the JSON string to redirect the current session or nil
    #   if the method has been called from inside a block
    def redirect(params={})
      hash = build_action('redirect', params)
      @response[:tropo] << hash
      render_response if @building.nil?
    end
    
    ##
    # Allows Tropo applications to reject incoming calls before they are answered. 
    # For example, an application could inspect the callerID variable to determine if the caller is known, 
    # and then use the reject call accordingly.
    #
    # @return [String, nil] the JSON string to reject the current session or nil
    #   if the method has been called from inside a block
    def reject
      @response[:tropo] << { :reject => nil }
      render_response if @building.nil?
    end
    
    ##
    # Renders the JSON string to be sent to Tropo to execute a set of actions
    #
    # @return [String] the JSON string to be sent to the Tropo Remote API
    def response
      @response.to_json
    end
    
    ##
    # Resets the action hash if one desires to reuse the same Generator object
    #
    # @return [nil]
    def reset
      @response = { :tropo => Array.new }
      @voice_session = false
      @text_session = false
    end
    
    ##
    # Plays a prompt (audio file, text to speech or text for IM/SMS). There is no ability to wait for a response from a user.
    # An audio file used for playback may be in one of the following two formats:
    #  Wav 8bit 8khz Ulaw
    #  MP3
    #
    # @overload say(params)
    #   @param [Hash] params the options to create a message with.
    #   @option params [required, String] :value the text or audio to be spoken or played back to the user
    #   @option params [optional, String] :voice (allison) specifies the voice to be used when speaking text to a user
    #   @option params [optional, String] :name this is the key used to identify the result of an operation, so you can differentiate between multiple results
    #   @option params [optional, Boolean] :required (true) determines whether Tropo should move on to the next verb - if true, Tropo will only move on if the current operation completed
    #   @option params [optional, Integer] :as specifies the type of data being spoken, so the TTS Engine can interpret it correctly. The possible values are "DATE", "DIGITS" and "NUMBER"
    #   @option params [optional, String or Array] :allow_signals allows you to assign a signal to say which can be used with REST to interrupt the function 
    # @overload say(params, &block)
    #   @param [Hash] params the options to create a message with.
    #   @param [Block] takes a block so that you may trigger actions, such as a say, on a specific event
    #   @option params [required, String] :value the text or audio to be spoken or played back to the user
    #   @option params [optional, String] :voice (allison) specifies the voice to be used when speaking text to a user
    #   @option params [optional, String] :name this is the key used to identify the result of an operation, so you can differentiate between multiple results
    #   @option params [optional, Boolean] :required (true) determines whether Tropo should move on to the next verb - if true, Tropo will only move on if the current operation completed
    #   @option params [optional, Integer] :as specifies the type of data being spoken, so the TTS Engine can interpret it correctly. The possible values are "DATE", "DIGITS" and "NUMBER"
    #   @option params [optional, String or Array] :allow_signals allows you to assign a signal to say which can be used with REST to interrupt the function 
    # @return [String, nil] the JSON string to be passed back to Tropo or nil
    #     if the method has been called from inside a block
    def say(value=nil, params={})
      
      # This will allow a string to be passed to the say, as opposed to always having to specify a :value key/pair,
      # or still allow a hash or Array to be passed as well
      if value.kind_of? String
        params[:value] = value
      elsif value.kind_of? Hash
        params = value
      elsif value.kind_of? Array
        params = value
      else
        raise ArgumentError, "An invalid paramater type #{value.class} has been passed"
      end
      
      response = { :say => Array.new }

      if params.kind_of? Array
        params.each do |param|
          param = set_language(param)
          hash = build_action('say', param)
          response[:say] << hash
        end
      else
        params = set_language(params)
        hash = build_action('say', params)
        response[:say] << hash
      end
      
      if @nested_hash && @nested_on_hash.nil?
        @nested_hash[@nested_name.to_sym].merge!(response)
      elsif @nested_on_hash
        @nested_on_hash[:on][@nested_on_hash_cnt].merge!(response)
        @nested_on_hash_cnt += 1
      else
        @response[:tropo] << response
        render_response if @building.nil?
      end
    end
    
    ##
    # Allows Tropo applications to begin recording the current session. 
    # The resulting recording may then be sent via FTP or an HTTP POST/Multipart Form.
    #
    # @param [Hash] params the options to create a message with.
    # @option params [required, String] :url a valid URI, an HTTP, FTP or email address to POST the recording file to
    # @option params [optional, String] :format (audio/wav) the audio format to record in, either a wav or mp3
    # @option params [optional, String] :username if posting to FTP, the username for the FTP server
    # @option params [optional, String] :password if posting to FTP, the password for the FTP server
    # @option params [optional, String] :method (POST) defines how to send the audio file - values are POST or PUT and applies only to HTTP
    # @return [String, nil] returns the JSON string to start the recording of a session or nil
    #   if the method has been called from inside a block
    def start_recording(params={})
      if block_given?
        create_nested_hash('start_recording', params)
        instance_exec(&block)
        @response[:tropo] << @nested_hash
      else
        hash = build_action('start_recording', params)
        @response[:tropo] << hash
      end
      render_response if @building.nil?
    end
    alias :start_call_recording :start_recording

    ##
    # Stops the recording of the current session after startCallRecording has been called
    #
    # @return [String, nil] returns the JSON string to stop the recording of a session or nil
    #   if the method has been called from inside a block
    def stop_recording
      @response[:tropo] << { :stopRecording => nil }
      render_response if @building.nil?
    end
    alias :stop_call_recording :stop_recording
    
    ##
    # Transfers an already answered call to another destination / phone number. 
    # Call may be transferred to another phone number or SIP address, which is set through the "to" parameter and is in URL format. 
    # Supported formats include:
    #  tel: classic phone number (See RFC 2896), must be proceeded by a + and the country code (ie - +14155551212 for a US #)
    #  sip: SIP protocol address
    #
    # When this method is called the following occurs:
    #  The audio file specified in playvalue is played to the existing call. This could be "hold music", a ring-back sound, etc. The audio file is played up to playrepeat times.
    #  While audio is playing, a new call is initiated to the specified "to" address using the callerID specified.
    #  If answerOnMedia is true, the audio from the new call is connected to the existing call immediately.
    #  The system waits for an answer or other event from the new call up to the timeout.
    #  If the call successfully completes within the timeout, the existing call and new call will be connected, onSuccess will be called, and the transfer call will return a success event.
    #  If the call fails before the timeout, onCallFailure will be called and the method will return an onCallFailure event.
    #  If the call fails due to the timeout elapsing, onTimeout will be called and the method will return a timeout event
    #
    # @overload transfer(params)
    #   @param [Hash] params the options to create a transfer action request with
    #   @option params [required, String] :to the new destination for the incoming call as a URL
    #   @option params [optional, String] :from set the from id for the session when redirecting
    #   @option params [optional, Integer] :interdigit_timeout (nil) defines how long to wait between key presses to determine the user has stopped entering input
    #   @option params [optional, Integer] :ring_repeat This specifies the number of times the audio file specified in the ring event will repeat itself.
    #   @option params [optional, String] :name this is the key used to identify the result of an operation, so you can differentiate between multiple results
    #   @option params [optional, Boolean] :required (true) determines whether Tropo should move on to the next verb - if true, Tropo will only move on if the current operation completed
    #   @option params [optional, Float] :timeout amount of time Tropo will wait--in seconds--for the other party to answer the call
    #   @option params [optional, Integer] :interdigit_timeout (nil) defines how long to wait between key presses to determine the user has stopped entering input
    #   @option params [optional, String or Array] :allow_signals allows you to assign a signal to record which can be used with REST to interrupt the function 
    #   @option params [optional, String] :on adds event callback to enable "ring" event, which allows you to play an audio file or say something while the outbound call rings
    #   @option params [optional, Boolean] :answer_on_media (false) if true, the call will be concisdered answered and audio will being playing as soon as media is received (ringing, busy, etc)
    #   @options params [optional, Hash] :headers A set of key/values to apply as customer SIP headers to the outgoing call
    #   @option params [optional, String] :choices when used with transfer, this defines the terminator
    # @overload transfer(params, &block)
    #   @param [Hash] params the options to create a transfer action request with
    #   @param [Block] takes a block so that you may trigger actions, such as a say, on a specific event
    #   @option params [required, String] :to the new destination for the incoming call as a URL
    #   @option params [optional, String] :from set the from id for the session when redirecting
    #   @option params [optional, Integer] :ring_repeat This specifies the number of times the audio file specified in the ring event will repeat itself.
    #   @option params [optional, String] :name this is the key used to identify the result of an operation, so you can differentiate between multiple results
    #   @option params [optional, Boolean] :required (true) determines whether Tropo should move on to the next verb - if true, Tropo will only move on if the current operation completed
    #   @option params [optional, Float] :timeout amount of time Tropo will wait--in seconds--for the other party to answer the call
    #   @option params [optional, Integer] :interdigit_timeout (nil) defines how long to wait between key presses to determine the user has stopped entering input
    #   @option params [optional, String or Array] :allow_signals allows you to assign a signal to record which can be used with REST to interrupt the function 
    #   @option params [optional, String] :on adds event callback to enable "ring" event, which allows you to play an audio file or say something while the outbound call rings
    #   @option params [optional, Boolean] :answer_on_media (false) if true, the call will be concisdered answered and audio will being playing as soon as media is received (ringing, busy, etc)
    #   @options params [optional, Hash] :headers A set of key/values to apply as customer SIP headers to the outgoing call
    #   @option params [optional, String] :choices when used with transfer, this defines the terminator
    # @return [nil, String]
    def transfer(params={}, &block)
      if block_given?
        create_nested_hash('transfer', params)
        instance_exec(&block)
        @response[:tropo] << @nested_hash
      else
        hash = build_action('transfer', params)
        @response[:tropo] << hash
      end
      render_response if @building.nil?
    end
    
    ##
    # Returns the current hash object of the response, as opposed to JSON
    #
    # @return [Hash] the current hash of the response
    def to_hash
      @response
    end
    
    ##
    # Sets the default voice for the object
    #
    # @param [String] voice the value to set the default voice to
    def voice=(voice)
      @voice = voice
    end
  end
end