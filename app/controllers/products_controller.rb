class ProductsController < ApplicationController

  before_action :authenticate_user!
  before_action :find_product, only: %i[show edit update destroy add_to_wishlist]

  def index
    @products = Product.includes(:country).where(approval_status: 'Approved').page(params[:page])
    @cart_product_ids = current_user.cart_items.pluck(:product_id)
  end

  def new
    @product = Product.new
  end
  
  def create
    @product = Product.create!(product_params.merge(user_id: params[:user_id]))
    if @product.save
      redirect_to products_path, notice: "Product is successfully created. Wait for the admin approval." 
    else
      render 'new', notice: "An error while enlisting a new product!"
    end
  end

  def show
    @wishlist_product_ids = current_user.wishlist_products.includes(:product, product: [images_attachments: :blob]).pluck(:product_id)
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "Product information updated successfully."
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy!
      redirect_to products_path, notice: "Product is successfully deleted."
    else
      redirect_to root_path, notice: "Product cannot be deleted. Try Again!"
    end
  end
  
  def search_products
    @search_products = Product.where("material ILIKE ? OR vendor ILIKE ? country ILIKE ?", "%" + params[:q] + "%", "%" + params[:q] + "%",  "%" + params[:q] + "%")
  end 

  def my_products
    @my_products = current_user.products.includes(:country).order("created_at DESC")
  end

  def add_to_wishlist
    if !current_user.wishlist.present?
      wishlist = Wishlist.create(user_id: current_user.id)
    else
      wishlist = current_user.wishlist
    end
    @favorite_item = wishlist.wishlist_products.create(product_id: @product.id)
    if @favorite_item.save
      redirect_to wishlist_products_path, notice: "Product successfully added to your wishlist!"
    else
      redirect_to root_path, notice: "Product is already in your wishlist!"
    end
  end

  def all_products
    @subcategory = Subcategory.find(params[:subcategory_id])
    @products = @subcategory.products.includes([images_attachments: :blob]).page(params[:page])
  end

  private

  def product_params
    params.require(:product).permit(:product_name, :category_id, :subcategory_id, :price, :material, :vendor,
       :description, :stock_quantity, :shipping_fees, :tax, :available, :country_id, images: [])
  end

  def find_product
    @product = Product.find(params[:id])
  end
end