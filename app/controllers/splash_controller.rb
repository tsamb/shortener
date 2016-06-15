class SplashController < ApplicationController
  def splash
    redirect_to '/links' if logged_in?
  end
end
