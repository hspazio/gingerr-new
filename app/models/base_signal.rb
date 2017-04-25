class BaseSignal < ApplicationRecord
  PERCENT_OVERTIME = 1.1
  TYPES = {
    error:   'ErrorSignal'.freeze,
    success: 'SuccessSignal'.freeze,
  }.freeze

  self.table_name = 'signals'

  belongs_to :app
  belongs_to :endpoint

  validates :type, inclusion: TYPES.values
  validates :pid, numericality: { only_integer: true, greater_than: 0 }

  after_commit :cache_app_stats

  scope :recent,  ->(limit = 10) { order('created_at DESC').limit(limit) }

  def self.class_for_type(type)
    TYPES[type.to_sym]
  end

  def app_name
    app && app.name
  end

  def state
    error? ? :error : :success
  end

  def error?
    false
  end

  def endpoint_description
    endpoint && endpoint.description
  end

  def overtime?(signal_frequency)
    signal_frequency * PERCENT_OVERTIME < Time.zone.now - created_at
  end

  def cache_app_stats
    app.cache_stats
  end
end
