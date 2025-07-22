class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  enum :role, { cliente: 0, admin: 1 }

  has_many :orders
end
