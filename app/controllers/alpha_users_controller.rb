require "uuidtools"

class AlphaUsersController < ApplicationController
	
	def index
	end

	#This function is called when a user validate the form to subsribe at the Alpha Version.
	#It will be used after for the Beta version, and then removed.
	def create
		@alpha_user = AlphaUser.new(params[:alpha_user])
		@alpha_user.uuid = UUIDTools::UUID.random_create.to_s
		if (@alpha_user.save)
			success = I18n.t("email_added", email: params[:alpha_user][:email])
			UserMailer.alpha_user_confirm(@alpha_user[:email], @alpha_user[:uuid], request.protocol + request.host_with_port).deliver
		end

		if (@alpha_user[:email] == "")
			errors = I18n.t("empty_email")
		elsif (@alpha_user.errors.size > 0)
			errors = @alpha_user[:email] + ": " + @alpha_user.errors.messages.values.join
		end
		redirect_to "/", :flash => { :email_errors => errors, :email_success => success }
		
	end

	def destroy
		@alpha_user = AlphaUser.find_by_uuid(params[:uuid])
		email = @alpha_user.email
		if (@alpha_user && @alpha_user.destroy && email == params[:email])
			success = I18n.t("email_alpha_removed", email: email)
		else
			errors = I18n.t("email_alpha_removed_error", email: email)
		end
			
		redirect_to "/", :flash => { :email_success => success, :email_errors => errors }
	end
end