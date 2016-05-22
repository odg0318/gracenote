require 'session'
require 'digest'

class SessionManager
  @@options = {}

  attr_accessor :sessions

  def self.create_instance(options = {})
    instance = SessionManager.new(options)

    thread = Thread.new do
      puts 'thread started'

      while(true) 
        instance.update
        sleep(1)
      end
    end

    return instance
  end

  def initialize(options = {})
    @@options = options
    @sessions = {} 
  end

  def create(login_id)
    session_key = Digest::MD5.hexdigest(login_id + Time.now.to_s)
    session = Session.new(login_id, @@options[:session_expired_time_secs])
    session.ttl

    @sessions[session_key] = session

    return session_key
  end

  def delete(session_key)
    @sessions.delete(session_key)
  end

  def get(session_key)
    session = @sessions[session_key]

    unless session 
      return nil
    end

    session.ttl

    return session 
  end

  def update
    cleanup_session_keys= []

    @sessions.each do |session_key, session|
      if session.expired?
        cleanup_session_keys.push(session_key)
      end
    end

    cleanup_session_keys.each do |session_key|
      delete(session_key)
    end
  end
end

