class MerbAuthSliceActivation::Activations <  MerbAuthSliceActivation::Application

  private
  def redirect_after_activation
    message[:notice] = "Your membership has been activated!"
    redirect url(:member, session.user )
  end

end # MerbAuthSliceActivation::Activations
