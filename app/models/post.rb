class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :image

  before_destroy :purge_image
  validates :image, presence: true
  validate :image_validation

  validates :title, presence: true
  validates :content, presence: true

  include PgSearch::Model

  pg_search_scope :search_by_title_and_body, 
                  against: [:title, :content], 
                  using: {
                    tsearch: { prefix: true }
                  }

  private

  def purge_image
    image.purge
  end

  def image_validation
    if image.attached?
      if image.blob.byte_size > 1.megabyte
        errors.add(:image, 'size must be less than 1MB')
      end

      acceptable_types = ['image/jpeg', 'image/png', 'image/gif']
      unless acceptable_types.include?(image.blob.content_type)
        errors.add(:image, 'must be a JPEG, PNG, or GIF')
      end
    else
      errors.add(:image, 'must be attached')
    end
  end
end
