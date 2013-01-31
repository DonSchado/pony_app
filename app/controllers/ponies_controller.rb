class PoniesController < ApplicationController
  def new
    @pony = Pony.new
  end

  def create
    render :text => params[:pony]
  end
end