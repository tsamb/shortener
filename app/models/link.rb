class Link < ActiveRecord::Base
  has_many :requests

  def click_count
    requests.count
  end
end
