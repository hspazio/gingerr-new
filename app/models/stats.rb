module Stats
  class AppsStateSummary
    def initialize(apps = App.listing)
      @project_apps = apps
    end

    def call
      result = { ok: 0, unstable: 0, critical: 0 }

      @project_apps.each_with_object(result) { |app, data|
        data[app.stability_level] += 1
      }.to_a
    end
  end

  class RecentErrors
    def initialize(errors = Error)
      @errors = errors
    end

    def call
      @errors.last_month.group(:name).group_by_day('errors.created_at').count
    end
  end
end
