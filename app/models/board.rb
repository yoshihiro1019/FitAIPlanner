class Board < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
  mount_uploader :board_image, ImageUploader

  belongs_to :user
  validate :board_image_type
  has_many :bookmarks, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :board_image
  has_many :bookmarking_users, through: :bookmarks, source: :user
  private

  def board_image_type
    allowed_formats = %w[jpg jpeg png gif]
    return unless board_image.present? && !board_image.content_type.in?(allowed_formats.map { |format| "image/#{format}" })

    errors.add(:board_image, 'must be a JPEG, PNG, or GIF')
  end
end
