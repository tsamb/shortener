class Link < ActiveRecord::Base
  has_many :requests
  belongs_to :user

  def click_count
    requests.count
  end

  def user_agent_frequency
    requests.group("requests.user_agent").count
  end
end
