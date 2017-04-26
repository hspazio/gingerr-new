class AppStats
  def initialize(app)
    @app = app
  end

  def recent_signals_timeline
    stats = { error: {}, success: {} }
    signals = @app.recent_signals(50)
    dates = (signals.last.created_at.to_date..signals.first.created_at.to_date).to_a
    dates.each do |date|
      stats[:success][date] = 0
      stats[:error][date] = 0
    end
    signals.each do |signal|
      stats[signal.state][signal.created_at.to_date] += 1
    end
    stats.map{ |type, data| {name: type, data: data.to_a} }
  end
end
