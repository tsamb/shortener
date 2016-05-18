class Link < ActiveRecord::Base
  has_many :requests
  belongs_to :user

  def click_count
    requests.count
  end
end
