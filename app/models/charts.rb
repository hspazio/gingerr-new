module Charts
  COLORS = {
    orange: '#f0c75e',
    green:  '#89b94b',
    red:    '#e08f5d'
  }.freeze

  class DistanceBetweenSignals
    SAMPLE_SIZE = 50

    def initialize(app, view)
      @app = app
      @view = view
    end

    def render
      data = @app.distance_between_signals(SAMPLE_SIZE)
      @view.area_chart(data, options)
    end

    def options
      { library: { colors: [COLORS[:orange]] } }
    end
  end

  class RecentSignalsTimeline
    def initialize(app, view)
      @app = app
      @view = view
    end

    def render
      stats = { error: {}, success: {} }
      signals = @app.signals.limit(50)
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
end
