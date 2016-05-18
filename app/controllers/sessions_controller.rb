class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to :root, notice: 'Successfully logged in.'
    else
      flash.now[:error] = "Username or password incorrect"
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to :root, notice: 'Successfully logged out.'
  end
end
