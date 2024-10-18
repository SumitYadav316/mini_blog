module Api
  module V1
    class SessionsController < Devise::SessionsController
    	skip_before_action :verify_authenticity_token  # Skip CSRF verification for API

      respond_to :json

      def create
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)

        render json: { message: "Signed in successfully", user: resource }, status: :ok
      end

      def destroy
        signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
        render json: { message: "Signed out successfully" }, status: :ok
      end
    end
  end
end
