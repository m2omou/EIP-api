class AlphaUsersController < ApplicationController
	
	def index
	end

	def create
		@alpha_user = AlphaUser.new(params[:alpha_user])
		if (@alpha_user.save)
			success = "Your email " + params[:alpha_user][:email] + " has been well added! Congrat's!"
		end
		if (@alpha_user.errors.full_messages.size > 1)
			errors = @alpha_user.errors.full_messages.join("<br />")
		else
			errors = @alpha_user.errors.full_messages.join("")
		end
		# render 'edit'
		redirect_to "/", :flash => { :email_errors => errors, :email_success => success }
	end
end
