class PasswordResetsController < ApplicationController
  def new
  end
  
  def create
    respond_to do |format|
      begin
        user = User.find_by_email(params[:email])
        user.send_password_reset if user
        if user
          @data = {:resposeCode => 0, :responseMessage => "Email sent with password reset instructions.", :result => nil}
        else
          @data = {:resposeCode => 1, :responseMessage => "Email not found", :result => nil}
        end
      rescue ActiveRecord::RecordNotFound => e
        @data = {:resposeCode => 1, :responseMessage => "Email not found", :result => {:error => e.message}}
      end
    
        format.html { redirect_to root_url, :notice => "Email sent with password reset instructions." }
        format.json { render json: @data }
    end
  end
  
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end
  
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end
end
