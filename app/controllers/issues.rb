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
    raise Merb::Controller::Unauthenticated, 'You must be logged in to suggest issues' if session.user.nil?
    only_provides :html
    @issue = Issue.new(params[:issue])
    @issue_parents = Issue.find_all_by(:parent_id => nil)
    render
  end

  # POST /issues
  def create
    raise Merb::Controller::Unauthenticated, 'You must be logged in to suggest issues' if session.user.nil?
    @issue = Issue.new(params[:issue])
    if @issue.save
      redirect url(:issue, @issue)
    else
      render :new
    end
  end

  # GET /issues/:id/edit
  def edit
    raise Merb::Controller::Unauthenticated, 'You must be logged in to edit an issues' if session.user.nil?
    only_provides :html
    @issue = Issue.find_by_id(params[:id])
    @issue_parents = Issue.find_all_by(:parent_id => nil)
    raise NotFound unless @issue
    render
  end

  # PUT /issues/:id
  def update
    raise Merb::Controller::Unauthenticated, 'You must be logged in to edit an issues' if session.user.nil?
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
    raise Merb::Controller::Unauthenticated, 'You must be logged in to destroy an issues' if session.user.nil?
    @issue = Issue.find_by_id(params[:id])
    raise NotFound unless @issue
    if @issue.destroy
      redirect url(:issues)
    else
      raise BadRequest
    end
  end

end