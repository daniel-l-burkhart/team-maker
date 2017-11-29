class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper

  protected

  ##
  # Method that lets only admins access certain pages
  ##
  def authenticate_admin! (options={})
    if !administrator_signed_in?
      redirect_to '/administrators/sign_in', :notice => 'Only administrators can access that page.'
    end
  end

  ##
  # Method that lets only faculty access certain pages
  ##
  def authenticate_faculty! (options={})
    if !faculty_signed_in?
      redirect_to '/faculties/sign_in', :notice => 'Only faculty members can access that page.'
    end
  end

  def authenticate_higher_level! (options={})

    if !faculty_signed_in? && !administrator_signed_in?
      redirect_to root_path, notice: 'Only someone with higher credientials can access this information'
    end

  end

end
