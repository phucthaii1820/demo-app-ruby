class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable,
       :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :posts, dependent: :destroy
end
