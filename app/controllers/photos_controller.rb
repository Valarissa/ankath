class PhotosController < ApplicationController
  before_filter :authenticate, :except => [:index, :show]

  def index
    @photos = Photo.find(:all)
  end

  def show
    @photo = Photo.find(params[:id])

    render :partial => 'photos/image' if request.xhr?
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new
    params[:photo][:filename] = Photo.upload(params[:photo].delete(:image))
    @photo.update_attributes(params[:photo])
    @photo.save

    redirect_to @photo
  end

  def edit
    @photo = Photo.find(params[:id])
  end

  def update
    @photo = Photo.find(params[:id])
    @photo.update_attributes(params[:photo])

    redirect_to @photo
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
  end
end
