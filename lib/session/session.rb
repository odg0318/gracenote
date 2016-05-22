class Session
  @@session_expired_time_secs = 0

  attr_accessor :login_id, :updated_time

  def initialize(login_id, session_expired_time_secs)
    @login_id = login_id
    @@session_expired_time_secs = session_expired_time_secs
  end

  def ttl
    @updated_time = Time.now.to_i
  end

  def expired?
    return (Time.now.to_i - @updated_time) > @@session_expired_time_secs 
  end

  def get_login_id
    return @login_id
  end
end

