class Board < ApplicationRecord
  validates :title, presence: { message: 'を入力してください' }, length: { maximum: 255, message: 'は255文字以内で入力してください' }
  validates :body, presence: { message: 'を入力してください' }, length: { maximum: 65_535, message: 'は65535文字以内で入力してください' }

  belongs_to :user
end
