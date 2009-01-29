class Districts < Application
  # provides :xml, :yaml, :js

  # GET /districts
  def index
    @districts = District.find(:all)
    display @districts
  end

  # GET /districts/:id
  def show
    @district = District.find_by_id(params[:id])
    raise NotFound unless @district
    display @district
  end

  # GET /districts/new
  def new
    only_provides :html
    @district = District.new(params[:district])
    render
  end

  # POST /districts
  def create
    @district = District.new(params[:district])
    if @district.save
      redirect url(:district, @district)
    else
      render :new
    end
  end

  # GET /districts/:id/edit
  def edit
    only_provides :html
    @district = District.find_by_id(params[:id])
    raise NotFound unless @district
    render
  end

  # PUT /districts/:id
  def update
    @district = District.find_by_id(params[:id])
    raise NotFound unless @district
    if @district.update_attributes(params[:district])
      redirect url(:district, @district)
    else
      raise BadRequest
    end
  end

  # DELETE /districts/:id
  def destroy
    @district = District.find_by_id(params[:id])
    raise NotFound unless @district
    if @district.destroy
      redirect url(:districts)
    else
      raise BadRequest
    end
  end

end
