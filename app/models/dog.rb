class Dog < ApplicationRecord
  has_many_attached :images
  belongs_to :user
  has_many :likes, dependent: :destroy

  ## Get all Likes of a Dog
  def get_likes
    Like.all.select {|like| like.dog_id == self.id}
  end

  ## Get Dogs by Likes in the Past Hour
  def self.last_hour
    Dog.all.each do |dog|
      count = dog.get_likes.select {|like| Time.now - like.created_at <= 1.hour}.count
      dog.update_attribute(:likes_past_hour, count)
    end
    Dog.order(likes_past_hour: :desc)
  end
end
