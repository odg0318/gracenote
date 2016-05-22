module Api
  module Login
    def self.included(base)
      base.class_eval do
        post '/login' do
          has_params?(:login_id)

          login_id = params[:login_id]

          member = $members[login_id]

          if member.nil?
            raise BaseException, 'login failed'
          end

          unless member.password?(params[:password])
            raise BaseException, 'login failed'
          end

          session_key = $session_manager.create(params[:login_id])

          to_json({
            :session_key => session_key
          })
        end

        post '/logout' do
          authenticated?

          to_json({
            :result => true
          })
        end

      end
    end
  end
end
