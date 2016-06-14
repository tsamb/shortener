class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except: :reroute
  before_action :current_user_must_own_link, only: [:show, :edit, :update, :destroy]

  def reroute
    link = Link.find_by(short_url: params[:wildcard])
    if link
      Request.create(
        user_agent: request.headers["User-Agent"],
        accept_language: request.headers["Accept-Language"],
        path: request.path,
        link: link
        )
      redirect_to link.full_url
    else
      render plain: "404 Not Found", status: 404
    end
  end

  def index
    @links = current_user.links
  end

  def show
  end

  def new
    @link = Link.new
  end

  def edit
  end

  def create
    @link = Link.new(link_params)
      if @link.save
        redirect_to @link, notice: 'Link was successfully created.'
      else
        render :new
      end
    end
  end

  def update
      if @link.update(link_params)
        redirect_to @link, notice: 'Link was successfully updated.'
      else
        render :edit
      end
    end
  end

  def destroy
    @link.destroy
    redirect_to links_url, notice: 'Link was successfully destroyed.'
  end

  private
    def set_link
      @link = Link.find(params[:id])
    end

    def link_params
      params.require(:link).permit(:full_url, :short_url).merge(user: current_user)
    end

    def current_user_must_own_link
      render plain: "403 Unauthorized", status: 403 unless @link.user == current_user
    end
end
