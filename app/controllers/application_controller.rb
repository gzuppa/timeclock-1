class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_admin!
    unless current_user.is_admin?
      respond_to do |format|
        format.html { render :template => "errors/401", :status => :unauthorized }
        format.all { render :nothing => true, :status => :unauthorized }
      end
    end
  end

end
