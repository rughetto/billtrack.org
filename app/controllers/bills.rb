class Bills < Application
  # provides :xml, :yaml, :js

  # GET /bills
  def index
    @bills = Bill.paginate(:page => params[:page] || 1, :per_page => params[:per_page]||30, :order => "introduced_at DESC", :conditions => "ISNULL(type)")
    display @bills
  end

  # GET /bills/:id
  def show
    @bill = Bill.find_by_id(params[:id])
    raise NotFound unless @bill
    display @bill
  end
  
end
