class Recipe < ApplicationRecord
  STATUSES = %w[active archived].freeze

  has_rich_text :content

  # @todo add ability to select status for user
  enum status: STATUSES.each_with_object(h = {}) { |s, h| h[s] = s }, _default: STATUSES.first

  belongs_to :user
  # to query the attached ActionText directly
  has_one :action_text_rich_text, class_name: 'ActionText::RichText', as: :record

  validates :title, :status, presence: true

  scope :of_owner, ->(user) { where(user_id: user.id) }
  scope :ordered, -> { order(created_at: :desc) }
  scope :recent, ->(after_id, kount = 10) { ordered.where('id > ?', after_id).limit(kount) }

  def self.search(query)
    return where({}) if query.blank?

    joins(:action_text_rich_text)
      .where(
        'title LIKE :query OR action_text_rich_texts.body LIKE :query',
        query: "%#{query}%"
      )
  end
end
