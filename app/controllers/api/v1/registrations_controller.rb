# app/controllers/api/v1/registrations_controller.rb
module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      skip_before_action :verify_authenticity_token # Skip CSRF verification for API

      respond_to :json

      	def create
		  build_resource(sign_up_params)

		  if resource.save
		    render json: { message: "User created successfully", user: resource }, status: :created
		  else
		    render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
		  end
		end

      private

      def sign_up_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
