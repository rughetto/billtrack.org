class Issues < Application
  # provides :xml, :yaml, :js

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

  # GET /issues/new
  def new
    only_provides :html
    @issue = Issue.new(params[:issue])
    render
  end

  # POST /issues
  def create
    @issue = Issue.new(params[:issue])
    if @issue.save
      redirect url(:issue, @issue)
    else
      render :new
    end
  end

  # GET /issues/:id/edit
  def edit
    only_provides :html
    @issue = Issue.find_by_id(params[:id])
    raise NotFound unless @issue
    render
  end

  # PUT /issues/:id
  def update
    @issue = Issue.find_by_id(params[:id])
    raise NotFound unless @issue
    if @issue.update_attributes(params[:issue])
      redirect url(:issue, @issue)
    else
      raise BadRequest
    end
  end

  # DELETE /issues/:id
  def destroy
    @issue = Issue.find_by_id(params[:id])
    raise NotFound unless @issue
    if @issue.destroy
      redirect url(:issues)
    else
      raise BadRequest
    end
  end

end