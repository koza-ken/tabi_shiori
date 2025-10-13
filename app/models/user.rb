class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :display_name, length: { maximum: 20 }, allow_blank: true
  validates :provider, length: { maximum: 64 }, allow_blank: true
  validates :uid, presence: true, if: -> { provider.present? }
  validates :provider, presence: true, if: -> { uid.present? }
end
