class Members < Application
  # provides :xml, :yaml, :js
  # need to rewrite Member's to_xml method before making resources available in xml and json

  # GET /members
  def index
    @members = Member.find(:all)
    display @members
  end

  # GET /members/:id
  def show
    @member = Member.find_by_id(params[:id])
    raise NotFound unless @member
    
    if params[:view] == 'activation'
      render params[:view].to_sym
    elsif @member == session.user
      render :dashboard
    else
      display @member
    end      
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
      message[:notice] = 'Please activate your account by verifying your email!'
      redirect url(:member, @member, :view => 'activation')
    else
      render :new
    end
  end

  # GET /members/:id/edit
  def edit
    ensure_authenticated
    only_provides :html
    @member = Member.find_by_id( session.user.id )
    raise NotFound unless @member
    render
  end

  # PUT /members/:id
  def update
    ensure_authenticated
    @member = Member.find_by_id( session.user.id )
    raise NotFound unless @member
    if @member.update_attributes(params[:member])
      redirect resource(@member)
    else    
      render :edit
    end
  end

  # DELETE /members/:id
  # def destroy
  #   @member = Member.find_by_id(params[:id])
  #   raise NotFound unless @member
  #   if @member.destroy
  #     redirect url(:members)
  #   else
  #     raise BadRequest
  #   end
  # end

end
