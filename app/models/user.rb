class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :dogs, dependent: :destroy
  has_many :likes, dependent: :destroy 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
