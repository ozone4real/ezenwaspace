class Article < ApplicationRecord
  WORDS_PER_MINUTE = 200

  extend FriendlyId
  friendly_id :title, use: :slugged

  has_rich_text :content
  has_many_attached :images

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :published, -> { where(published: true) }
  scope :recent, -> { order(published_at: :desc) }

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def published?
    published && published_at.present?
  end

  def excerpt(length = 150)
    return "" if content.blank?

    # Strip HTML tags and get plain text
    plain_text = ActionText::Content.new(content).to_plain_text
    plain_text.length > length ? "#{plain_text[0...length]}..." : plain_text
  end

  def reading_time
    return 0 if content.blank?

    (content.body.to_plain_text.split.size / WORDS_PER_MINUTE).ceil
  end
end
