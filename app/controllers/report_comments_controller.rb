class ReportCommentsController < ApplicationController
  before_filter :restrict_access

  # POST /report_comments
  # POST /report_comments.json
  def create
    @report_comment = ReportComment.new(report_comment_params)

    respond_to do |format|
      if (Comment.exists?(:id => report_comment_params[:comment_id]))
        if @report_comment.save
          @data = {:responseCode => 0, :responseMessage => "success", :result => {:report => @report_comment}}
          format.html { redirect_to @report_comment, notice: 'Report comment was successfully created.' }
          format.json { render json: @data.as_json(:params => request.protocol + request.host_with_port) }
        else
          @data = {:responseCode => 1, :responseMessage => "error", :result => {:error => @report_comment.errors}}
          format.html { render action: 'new' }
          format.json { render json: @data }
        end
      else
        @data = {:responseCode => 1, :responseMessage => "comment_id doesn't exist", :result => nil}
        format.html { render action: 'new' }
        format.json { render json: @data }
      end
    end
  end

  private

  # ask for token access
  def restrict_access
    if  session[:user_id]
      if !report_comment_params.nil?
        report_comment_params[:user_id] = session[:user_id]
      end
    else
      authenticate_or_request_with_http_token do |token, options|
        @user = User.where(:auth_token => token).first()
        if (@user)
          if !report_comment_params.nil?
            report_comment_params[:user_id] = @user.id
          end
          return true
        end
        false
      end
    end
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_report_comment
      @report_comment = ReportComment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_comment_params
      params[:report_comment]
    end
end
