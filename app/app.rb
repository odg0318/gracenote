require 'sinatra/base'
require 'json'

require 'app/login'
require 'app/member'

class App < Sinatra::Base
  include Api::Login
  include Api::Member

  set :show_exceptions, :after_handler

  helpers do
    def authenticated?
      session_key = params[:session_key]
      if session_key.nil? 
        raise UnauthorizedException, 'auth required'
      end

      session = $session_manager.get(session_key)
      if session.nil?
        raise UnauthorizedException, 'auth required'
      end

      member = $members[session.get_login_id]
      if member.nil?
        raise UnauthorizedException, 'auth required'
      end

      @member = member
    end

    def has_params?(*required_params)
      required_params.each do |key, val|
        unless params[key]
          raise ParameterException, 'parameter not enough'
        end
      end
    end

    def to_json(hash)
      JSON.generate(hash)
    end
  end

  before do
    content_type 'application/json'
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, DELETE, PUT'
  end

  get '/' do
    'Hello world'
  end

  error BaseException do 
    exception = env['sinatra.error']

    status exception.get_code
    
    puts exception.message 

    to_json({
      :exception => exception.message
    })
  end

  error do
    exception = env['sinatra.error']

    status = 500

    to_json({
      :exception => exception.message
    })
  end
end
