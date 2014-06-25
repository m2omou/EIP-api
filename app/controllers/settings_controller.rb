class SettingsController < ApplicationController
  before_action :set_setting, only: [:show, :edit, :update, :destroy]
  before_filter :restrict_access

  # GET /settings/1
  # GET /settings/1.json
  def show
    begin
        @user_id = get_auth_token_user_id()
        @settings = Setting.find_by_user_id(@user_id)
        if (params[:id].to_s != @settings.id.to_s)
          @data = ApplicationHelper.jsonResponseFormat(1, "Error", {:error => "Must be the owner"})
        else
          @data = ApplicationHelper.jsonResponseFormat(0, "success", {:settings => @settings})
        end
    rescue ActiveRecord::RecordNotFound => e
        @data = ApplicationHelper.jsonResponseFormat(1, "Error", {:error => e.message})
    end
    respond_to do |format|
      format.json { render json: @data, :except=>  [:updated_at, :created_at, :user_id]}
    end
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    respond_to do |format|
      begin
        @user_id = get_auth_token_user_id()
        @setting = Setting.find_by_user_id(@user_id)
        if (params[:id].to_s != @setting.id.to_s)
          @data = ApplicationHelper.jsonResponseFormat(1, "error", {:error => "Must be the owner"})
          format.json { render json: @data }
        else
          if @setting.update(setting_params)
            @data = ApplicationHelper.jsonResponseFormat(0, "success", {:settings => @setting})
            format.html { redirect_to @setting, notice: 'Setting was successfully updated.' }
            format.json { render json:  @data, :except=>  [:updated_at, :created_at, :user_id] }
          else
            format.html { render action: 'edit' }
            format.json { render json: ApplicationHelper.jsonResponseFormat(1, "error", {:settings => @setting.errors}) }
          end
        end
      rescue ActiveRecord::RecordNotFound => e
        format.json { render json: ApplicationHelper.jsonResponseFormat(1, "error", :result => {:error => e.message}) }
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
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params[:setting]
    end
end
