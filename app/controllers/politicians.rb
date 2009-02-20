class Politicians < Application
  # provides :xml, :yaml, :js

  # GET /politicians
  def index
    @politicians = Politician.paginate(:page => params[:page]||1, :per_page => params[:per_page]||20,  :order => "last_name", :include => :id_lookups)
    display @politicians
  end

  # GET /politicians/:id
  def show
    @politician = Politician.find_by_id(params[:id])
    raise NotFound unless @politician
    display @politician
  end

end
