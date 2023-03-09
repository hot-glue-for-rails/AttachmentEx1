class ImagesController < ApplicationController
  # regenerate this controller with
  # rails generate hot_glue:scaffold Image --include='name:avatar' --gd --attachments='avatar{thumb|name}'

  helper :hot_glue
  include HotGlue::ControllerHelper

  
  before_action :load_image, only: [:show, :edit, :update, :destroy]
  after_action -> { flash.discard }, if: -> { request.format.symbol == :turbo_stream }
  
  
  def load_image
    @image = Image.find(params[:id])
  end
  

  def load_all_images
    @images = Image.page(params[:page])
  end

  def index
    load_all_images
  end

  def new
    @image = Image.new()
   
  end

  def create
 
    modified_params = modify_date_inputs_on_params(image_params.dup)
    modified_params[:name] = image_params['avatar'].original_filename
    @image = Image.create(modified_params)

    if @image.save
      flash[:notice] = "Successfully created #{@image.name}"
      load_all_images
      render :create
    else
      flash[:alert] = "Oops, your image could not be created. #{@hawk_alarm}"
      render :create, status: :unprocessable_entity
    end
  end


  def edit
    render :edit
  end

  def update
 
    
    modified_params = modify_date_inputs_on_params(image_params.dup)

    

    modified_params[:name] = image_params['avatar'].original_filename
    if @image.update(modified_params)
      
      flash[:notice] = (flash[:notice] || "") << "Saved #{@image.name}"
      flash[:alert] = @hawk_alarm if @hawk_alarm
      render :update
    else
      flash[:alert] = (flash[:alert] || "") << "Image could not be saved. #{@hawk_alarm}"
      render :update, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @image.destroy
    rescue StandardError => e
      flash[:alert] = 'Image could not be deleted.'
    end
    load_all_images
  end

  def image_params
    params.require(:image).permit([:name, :avatar])
  end

  def namespace
    
  end
end


