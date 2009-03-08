class Issues < Application
  provides :xml, :json

  # GET /issues
  def index
    @issues = Issue.find(:all)
    display @issues
  end

  # GET /issues/:id
  def show
    @issue = Issue.find_by_id(params[:id])
    raise NotFound unless @issue
    display @issue
  end

  # POST /issues
  def create
    ensure_authenticated
    @issue = Issue.new(params[:issue])
    if @issue.save
      redirect url(:issue, @issue)
    else
      render :new
    end
  end
  
end # Issues

