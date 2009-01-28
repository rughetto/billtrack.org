class Members < Application
  # provides :xml, :yaml, :js

  # GET /members
  def index
    @members = Member.find(:all)
    display @members
  end

  # GET /members/:id
  def show
    @member = Member.find_by_id(params[:id])
    raise NotFound unless @member
    display @member
  end

  # GET /members/new
  def new
    only_provides :html
    @member = Member.new(params[:member])
    render
  end

  # POST /members
  def create
    @member = Member.new(params[:member])
    if @member.save
      redirect url(:member, @member)
    else
      render :new
    end
  end

  # GET /members/:id/edit
  def edit
    only_provides :html
    @member = Member.find_by_id(params[:id])
    raise NotFound unless @member
    render
  end

  # PUT /members/:id
  def update
    @member = Member.find_by_id(params[:id])
    raise NotFound unless @member
    if @member.update_attributes(params[:member])
      redirect url(:member, @member)
    else
      raise BadRequest
    end
  end

  # DELETE /members/:id
  def destroy
    @member = Member.find_by_id(params[:id])
    raise NotFound unless @member
    if @member.destroy
      redirect url(:members)
    else
      raise BadRequest
    end
  end

end
