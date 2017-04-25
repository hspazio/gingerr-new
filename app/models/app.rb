class App < ApplicationRecord
  has_many :signals, -> { order('created_at DESC, id DESC') }

  validates :name, presence: true

  scope :listing, -> { order(:name) }

  def recent_signals(limit = 10)
    signals.limit(limit)
  end

  def current_signal_state
    current_signal && current_signal.state
  end

  def current_signal_created_at
    current_signal && current_signal.created_at
  end

  def current_signal
    @current_signal ||= recent_signals.take
  end

  def distance_between_signals(limit)
    recent_signals(limit).reverse.each_cons(2).map { |sig1, sig2|
      [sig2.created_at.to_s, sig2.created_at - sig1.created_at]
    }
  end

  def signal_frequency_in_hours
    "#{(signal_frequency / 3600)} sig/h"
  end

  def stability_level
    case stability_score
    when 100       then :ok
    when (0..70)   then :critical
    when (70..100) then :unstable
    end
  end

  def stats
    @stats ||= AppStats.new(self)
  end

  def require_alert?(signal_frequency)
    current_signal.success? && current_signal.overtime?(signal_frequency)
  end

  def cache_stats
    update_attributes(
      signal_frequency: calculate_signal_frequency,
      stability_score:  calculate_stability_score
    )
  end

  private

  def calculate_signal_frequency
    signals = recent_signals
    if (count_signals = signals.count)
      (signals.first.created_at - signals.last.created_at).to_f / count_signals
    end
  end

  def calculate_stability_score
    (count_recent_success_signals.to_f * 100 / count_recent_signals).round
  end

  def count_recent_signals
    recent_signals.count
  end

  def count_recent_success_signals
    recent_signals.each.count(&:success?)
  end
end
