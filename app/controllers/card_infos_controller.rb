class CardInfosController < ApplicationController
  def show
    @card = current_user.card_info
  end
end
