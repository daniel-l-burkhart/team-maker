class WelcomeController < ApplicationController

  ##
  # Index method
  ##
  def index
  end

  ##
  # Creates a new session
  ##
  def new
    @session = Session.new('')
  end

  ##
  # Login
  ##
  def login
  end

  ##
  # Forgot
  ##
  def forgot
  end

  ##
  # About
  ##
  def about
  end

end
