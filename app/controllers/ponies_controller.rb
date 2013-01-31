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

  def index
    @ponies = Pony.all
  end

  def delete_all
    Pony.delete_all
    redirect_to :home_page, notice: "Killed all the ponies..."
  end
end