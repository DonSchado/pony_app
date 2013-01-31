class PoniesController < ApplicationController
  def new
    @pony = Pony.new
  end

  def create
    @pony = Pony.create(params[:pony])
    if @pony.save
      redirect_to pony_path(@pony)
    else
      render "new"
    end
  end

  def show
    @pony = Pony.find(params[:id])
  end
end