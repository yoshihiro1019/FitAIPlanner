class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, presence: true, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password].present? }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password].present? }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password].present? }
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name,  presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  has_many :boards, dependent: :destroy
  has_many :comments, dependent: :destroy
  def full_name
    "#{first_name} #{last_name}"
  end
end
