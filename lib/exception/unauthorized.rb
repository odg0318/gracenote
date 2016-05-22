class UnauthorizedException < BaseException
  def get_code
    return 401
  end
end
