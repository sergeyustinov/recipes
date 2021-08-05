class User < ApplicationRecord
  ROLES = %w[simple admin].freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: ROLES.each_with_object(h = {}) { |r, h| h[r] = r }, _default: ROLES.first

  has_many :recipes, dependent: :destroy

  validates :first_name, :email, :role, presence: true

  def owner_of?(inst)
    inst.respond_to?(:user_id) && inst.user_id == id
  end
end
