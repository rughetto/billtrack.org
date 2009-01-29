class Politicians < Application
  # provides :xml, :yaml, :js

  # GET /politicians
  def index
    @politicians = Politician.find(:all)
    display @politicians
  end

  # GET /politicians/:id
  def show
    @politician = Politician.find_by_id(params[:id])
    raise NotFound unless @politician
    display @politician
  end

  # GET /politicians/new
  def new
    only_provides :html
    @politician = Politician.new(params[:politician])
    render
  end

  # POST /politicians
  def create
    @politician = Politician.new(params[:politician])
    if @politician.save
      redirect url(:politician, @politician)
    else
      render :new
    end
  end

  # GET /politicians/:id/edit
  def edit
    only_provides :html
    @politician = Politician.find_by_id(params[:id])
    raise NotFound unless @politician
    render
  end

  # PUT /politicians/:id
  def update
    @politician = Politician.find_by_id(params[:id])
    raise NotFound unless @politician
    if @politician.update_attributes(params[:politician])
      redirect url(:politician, @politician)
    else
      raise BadRequest
    end
  end

  # DELETE /politicians/:id
  def destroy
    @politician = Politician.find_by_id(params[:id])
    raise NotFound unless @politician
    if @politician.destroy
      redirect url(:politicians)
    else
      raise BadRequest
    end
  end

end
