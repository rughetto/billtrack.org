class Parties < Application
  # provides :xml, :yaml, :js

  # GET /parties
  def index
    @parties = Party.find(:all)
    display @parties
  end

  # GET /parties/:id
  def show
    @party = Party.find_by_id(params[:id])
    raise NotFound unless @party
    display @party
  end

  # GET /parties/new
  def new
    only_provides :html
    @party = Party.new(params[:party])
    render
  end

  # POST /parties
  def create
    @party = Party.new(params[:party])
    if @party.save
      redirect url(:party, @party)
    else
      render :new
    end
  end

  # GET /parties/:id/edit
  def edit
    only_provides :html
    @party = Party.find_by_id(params[:id])
    raise NotFound unless @party
    render
  end

  # PUT /parties/:id
  def update
    @party = Party.find_by_id(params[:id])
    raise NotFound unless @party
    if @party.update_attributes(params[:party])
      redirect url(:party, @party)
    else
      raise BadRequest
    end
  end

  # DELETE /parties/:id
  def destroy
    @party = Party.find_by_id(params[:id])
    raise NotFound unless @party
    if @party.destroy
      redirect url(:parties)
    else
      raise BadRequest
    end
  end

end
