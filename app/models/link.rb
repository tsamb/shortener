class Link < ActiveRecord::Base
  has_many :requests
  belongs_to :user

  validates :full_url, :short_url, presence: true
  validates :full_url, exclusion: { in: ["http://"], message: "can't be blank" }

  def click_count
    requests.count
  end

  def has_clicks?
    click_count > 0
  end

  def user_agent_frequency
    requests.group("requests.user_agent").count
  end
end
