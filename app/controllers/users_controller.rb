class UsersController < ApplicationController

  before_action :authenticate_user!, except: %i[new create about_us]
  before_action :find_user, except: %i[index new create about_us]

  def index
  end
  
  def show
  end
  
  def update
    if @user.update(user_params)
      redirect_to users_path(@user.id), flash[:notice] = "User information updated successfully."
    else
      redirect_to root_path, flash[:notice] = "User information cannot be updated."
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path, notice: "You account has been successfully deleted."
  end

  def about_us
  end

  def confirm
    user = User.find_by(confirmation_token: params[:confirmation_token])
    if user
      user.update(confirmed_at: Time.now)
      redirect_to root_url, notice: "Your account has been confirmed. Please complete your profile first."
    else
      redirect_to root_url, alert: "Invalid confirmation token."
    end
  end

  private

  def user_params
    params.permit(:user).require(:image, :first_name, :last_name, :email, :password, :password_confirmation, :phone_number, :dob, :role)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
