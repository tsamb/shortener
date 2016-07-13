class SplashController < ApplicationController
  def splash
    if logged_in?
      redirect_to '/links'
    else
      redirect_to 'http://www.samuelrblackman.com'
    end
  end
end
