class Micropost < ApplicationRecord
  MICROPOST_PERMIT = %i(content image).freeze

  belongs_to :user
  has_one_attached :image

  scope :newest, -> {order(created_at: :desc)}

  validates :content, presence: true,
            length: {maximum: Settings.micropost.max_content_length}
  validate :image_format
  validate :image_size

  private

  def image_format
    return unless image.attached?

    acceptable_types = Settings.micropost.allowed_mime_types
    return if acceptable_types.include?(image.blob.content_type)

    errors.add(:image, :invalid_format)
  end

  def image_size
    return unless image.attached?
    return unless image.blob.byte_size >
                  Settings.micropost.max_image_size.megabytes

    errors.add(:image, :too_large, size: Settings.micropost.max_image_size)
  end
end
