class Note < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :text, length: { maximum: 1000 }
  validates :user_id, presence: true

  before_validation :check_title_and_assign

  default_scope { order(updated_at: :desc) }

  belongs_to :user

  def self.search(term)
    where('notes.title ILIKE :term OR notes.text ILIKE :term', term: "%#{term}%")
  end

  private

  def check_title_and_assign
    return if title.present?

    self.title = text[0..29] if text
  end
end
