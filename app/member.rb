module Api
  module Member 
    def self.included(base)
      base.class_eval do
        get '/members' do
          authenticated?

          to_json(@member.to_hash)
        end

        put '/members' do
          authenticated?
          has_params?(:name)

          @member.name = params[:name]

          to_json(@member.to_hash)
        end
      end
    end
  end
end
