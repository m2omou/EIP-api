class AlphaUsersController < ApplicationController
	
	def index
	end

	#This function is called when a user validate the form to subsribe at the Alpha Version.
	#It will be used after for the Beta version, and then removed.
	def create
		@alpha_user = AlphaUser.new(params[:alpha_user])
		if (@alpha_user.save)
			success = I18n.t("email_added", email: params[:alpha_user][:email])
		end

		if (@alpha_user[:email] == "")
			errors = I18n.t("empty_email")
		elsif (@alpha_user.errors.size > 0)
			errors = @alpha_user[:email] + ": " + @alpha_user.errors.messages.values.join
		end
		redirect_to "/", :flash => { :email_errors => errors, :email_success => success }
		
	end

	def destroy
		@alpha_user = AlphaUser.new(params[:email])
		@alpha_user.destroy
	end
end
