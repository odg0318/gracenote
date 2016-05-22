class Member
  attr_accessor :login_id, :password, :name

  def initialize(login_id, password, name)
    @login_id = login_id
    @password = password
    @name = name
  end

  def password?(password)
    return @password == password
  end

  def to_hash
    return {
      :login_id => @login_id,
      :name => @name
    }
  end
end
