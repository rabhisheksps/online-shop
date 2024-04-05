class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def update_status
    event = Event.create!(
      data: params,
      source: params[:source],
    )
    HandleEventJob.perform_later(event)
    render json: {status: :ok}
  end
end