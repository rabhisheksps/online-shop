class CategoriesController < ApplicationController

  before_action :authenticate_user!
  before_action :find_category, except: %i[index new create]

  def index
    @categories = Category.where(approval_status: 'Approved').includes(image_attachment: :blob).order(:category_name).page(params[:page])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.create(category_params)
    if @category.save
      redirect_to categories_path, notice: "New category added successfully. Wait for the admin approval."
    else
      render :new, notice: "New category cannot be added.Please enter details correctly."
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: "Category information successfully updated."
    else
      render :edit, notice: "Please enter details correctly!"
    end
  end

  def destroy
    if @category.destroy
      redirect_to categories_path, notice: "Category is successfully deleted."
    else
      redirect_to root_path, notice: "Category cannot be deleted. Try Again!"
    end
  end

  private

  def find_category
    @category = Category.find(params[:id])
  end
  
  def category_params
    params.require(:category).permit(:category_name, :image)
  end
end