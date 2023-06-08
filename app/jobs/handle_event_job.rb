class HandleEventJob < ApplicationJob
  queue_as :default

  def perform(event)
  end
end
