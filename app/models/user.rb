class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # groupモデルでcreatorにしたのでuserモデルもあわせておく
  has_many :created_groups, class_name: "Group", foreign_key: "created_by_user_id", inverse_of: :creator
  has_many :cards, dependent: :destroy
  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships
  validates :display_name, length: { maximum: 20 }, allow_blank: true
  validates :provider, presence: true, if: -> { uid.present? }, length: { maximum: 64 }, allow_blank: true
  validates :uid, presence: true, if: -> { provider.present? }
end
