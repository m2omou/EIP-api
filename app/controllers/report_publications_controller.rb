class ReportPublicationsController < ApplicationController
  before_filter :restrict_access

  # POST /report_publications
  # POST /report_publications.json
  def create
    @report_publication = ReportPublication.new(report_publication_params)

    respond_to do |format|
      if (Publication.exists?(:id => report_publication_params[:publication_id]))
        if @report_publication.save
          @data = {:responseCode => 0, :responseMessage => "success", :result => {:report => @report_publication}}
          format.html { redirect_to @report_publication, notice: 'Report publication was successfully created.' }
          format.json { render json: @data.as_json(:params => request.protocol + request.host_with_port) }
        else
          @data = {:responseCode => 1, :responseMessage => "error", :result => {:error => @report_publication.errors}}
          format.html { render action: 'new' }
          format.json { render json: @data }
        end
      else
        @data = {:responseCode => 1, :responseMessage => "publication_id doesn't exist", :result => nil}
        format.html { render action: 'new' }
        format.json { render json: @data }
      end
    end
  end

  private

  # ask for token access
  def restrict_access
    unless  session[:user_id]
      authenticate_or_request_with_http_token do |token, options|
        @user = User.where(:auth_token => token).first()
        if (@user)
          if !report_publication_params.nil?
            report_publication_params[:user_id] = @user.id
          end
          return true
        end
        false
      end
    end
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_report_publication
      @report_publication = ReportPublication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_publication_params
      params[:report_publication]
    end
end
