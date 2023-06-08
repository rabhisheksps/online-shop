class SubcategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_category, only: %i[index new create]
  before_action :find_subcategory, except: %i[index new create ]

  def index
    @category = Category.find(params[:category_id])
    @subcategories = @category.subcategories.where(approval_status: 'Approved').includes(image_attachment: :blob).order(:subcategory_name).page(params[:page])
  end

  def new
    @category = Category.find(params[:category_id])
    @subcategory =  @category.subcategories.new
  end

  def create
    @category = Category.find(params[:category_id])
    @subcategory = @category.subcategories.create!(subcategory_params)
    if @subcategory.save
      redirect_to category_subcategories_path(@category.id), notice: "New subcategory added. Wait for the admin approval"
    else
      render :new, notice: "New category cannot be added.Please enter details correctly!"
    end
  end

  def edit
  end

  def update
    if @subcategory.update(subcategory_params)
      redirect_to categories_path, notice: "Subcategory information successfully updated."
    else
      render :edit, notice: "Please enter details correctly!"
    end
  end

  def destroy
    if @subcategory.destroy
      redirect_to root_path, notice: "Subcategory is successfully deleted."
    else
      redirect_to root_path, notice: "Subcategory cannot be deleted. Try Again!"
    end
  end

  private
  
  def find_subcategory
    @subcategory = Subcategory.find(params[:id])
  end

  def find_category
    @category = Category.find(params[:category_id])
  end

  def subcategory_params
    params.require(:subcategory).permit(:subcategory_name, :image)
  end
end