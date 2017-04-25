class Error < ApplicationRecord
  belongs_to :signal, class_name: 'ErrorSignal'

  validates :name, presence: true
  validates :message, presence: true
  validates :file, presence: true
  validates :backtrace, presence: true

  scope :by_name, ->(name) { where(name: name).order(:created_at) }
  scope :last_month, -> { where("errors.created_at >= '#{1.month.ago}'") }
  scope :by_app, ->(app) { 
    joins(:signal, signal: :app)
      .where(gingerr_signals: { app_id: app}) 
  }

  def self.first_seen_by_name(name)
    by_name(name).pluck(:created_at).first
  end

  def self.last_seen_by_name(name)
    by_name(name).pluck(:created_at).last
  end

  def self.count_by_name(name)
    by_name(name).count
  end
end
