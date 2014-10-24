class ReportPublicationsController < ApplicationController
  before_filter :restrict_access

  def index
    # for the back office
    if (current_user && current_user.role == BackOfficeRoles::ADMIN)
      @report_publications = ReportPublication.all()
      return render :html => @report_publications
    end
  end

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


  def show
    @report_publication = ReportPublication.find(params[:id])
  end


  def edit
    @report_publication = ReportPublication.find(params[:id])
  end

  def update
    @report_publication = ReportPublication.find(params[:id])

    # for the back office
    if (current_user && current_user.role == BackOfficeRoles::ADMIN)
      @report_publication = ReportPublication.find(params[:id])
      @report_publication.update_attributes(params[:report_publication])
      redirect_to @report_publication
    end
  end

  def destroy
    if (current_user && current_user.role == BackOfficeRoles::ADMIN)
      @report_publication = ReportPublication.find(params[:id])
      @report_publication.destroy
      redirect_to report_publications_url
    end
  end

  private

  # ask for token access
  def restrict_access
    if  session[:user_id]
      if !report_publication_params.nil?
        report_publication_params[:user_id] = session[:user_id]
      end
    else
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
