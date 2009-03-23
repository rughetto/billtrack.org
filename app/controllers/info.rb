class Info < Application
  def show
    render :template => "info/" + params[:template_path]
  end  
end  