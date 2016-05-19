class Request < ActiveRecord::Base
  belongs_to :link

  validates :link, presence: true
end
