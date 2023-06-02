class AddressesController < ApplicationController

  before_action :authenticate_user!, except: %i[new create about_us]
  before_action :find_address, except: %i[index new create]

  def index
    @addresses = current_user.addresses.order("created_at DESC")
  end

  def new
    @address = current_user.addresses.new
  end

  def create
    @address = current_user.addresses.new(address_params)
    if @address.save
      flash[:notice] = "Successfully created address."
      redirect_to addresses_path
    else
      flash[:notice] = "An error while saving a new address"
    end
  end

  def edit
  end

  def update
    if @address.update(address_params)
      redirect_to addresses_path, notice: "Address information updated successfully."
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @address.destroy
    flash[:notice] = "Address successfully removed."
    redirect_to addresses_path
  end

  private

  def address_params
    params.require(:address).permit(:address_type, :address_line_1, :city, :state, :country, :pincode)
  end

  def find_address
    @address = Address.find(params[:id])
  end
end