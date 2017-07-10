class FetchDelegatorsJob < ApplicationJob
  queue :fetch_delegators

  after_perform do |job|
    self.set(wait_until: 12.hours.from_now)
  end

  def perform
  end

end