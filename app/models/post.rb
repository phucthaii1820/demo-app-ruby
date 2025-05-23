class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :title, :content, :category_id, presence: true
end
