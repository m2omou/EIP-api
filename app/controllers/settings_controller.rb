class SettingsController < ApplicationController
  before_action :set_setting, only: [:show, :edit, :update, :destroy]
  before_filter :restrict_access

  # GET /settings
  # GET /settings.json
  def index
    @auth_user_id = get_auth_token_user_id()
    @user_id = @auth_user_id == -1 ? params[:user_id] : @auth_user_id
    begin
      @settings = Setting.find_by_user_id(@user_id)
      @data = ApplicationHelper.jsonResponseFormat(0, "success", {:settings => @settings})
    rescue ActiveRecord::RecordNotFound => e
      @data = ApplicationHelper.jsonResponseFormat(1, "Error", {:error => e.message})
    end

    respond_to do |format|
      format.json { render json: @data, :except=>  [:updated_at, :created_at]}
    end
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to @setting, notice: 'Setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # ask for token access
  def restrict_access
    if  session[:user_id]
      if !setting_params.nil?
        setting_params[:user_id] = session[:user_id]
      end
    else
      authenticate_or_request_with_http_token do |token, options|
        @user = User.where(:auth_token => token).first()
        if (@user)
          if !setting_params.nil?
            setting_params[:user_id] = @user.id
          end
          return true
        end
        false
      end
    end
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params[:setting]
    end
end
