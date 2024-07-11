class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, presence: true, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password].present? }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password].present? }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password].present? }
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name,  presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :reset_password_token, uniqueness: true, allow_nil: true
  has_many :boards, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_boards, through: :bookmarks, source: :board
  mount_uploader :avatar, AvatarUploader
  enum role: { general: 0,  admin: 1 }
  
  include EnumHelp
  def full_name
    "#{last_name} #{first_name}"
  end

  def bookmarked?(board)
    bookmarked_boards.include?(board)
  end

  def own?(resource)
    resource.user_id == id
  end

  def bookmark(board)
    bookmarks.create(board:)
  end

  def unbookmark(board)
    bookmarks.find_by(board:).destroy
  end

  
end
