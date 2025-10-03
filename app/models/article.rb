class Article < ApplicationRecord
  WORDS_PER_MINUTE = 200

  extend FriendlyId
  friendly_id :title, use: :slugged

  has_rich_text :content
  has_many_attached :images
  has_many :article_tags, autosave: true, dependent: :destroy
  has_many :tags, through: :article_tags
  accepts_nested_attributes_for :article_tags, allow_destroy: true

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

  # Tag list methods for easy form handling
  def tag_list
    tags.pluck(:name).join(", ")
  end

  def tag_list=(names)
    # Parse and create new tags
    tag_names = names.to_s.split(",").map(&:strip).reject(&:blank?).uniq
    tags_to_create = tag_names - tags.pluck(:name)
    tags_to_destroy = tags.pluck(:name) - tag_names
    tags_to_create.each do |name|
      self.tags << Tag.find_or_initialize_by(name: name.downcase)
    end
    article_tags.each do |article_tag|
      if tags_to_destroy.include?(article_tag.tag.name)
        article_tag.mark_for_destruction
      end
    end
  end
end
