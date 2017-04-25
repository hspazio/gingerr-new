module ApplicationHelper
  def signal_type(signal)
    if signal.error?
      error_label
    else
      success_label
    end
  end

  def error_label
    content_tag :span, class: 'label label-danger' do
      'Error'
    end
  end

  def success_label
    content_tag :span, class: 'label label-success' do
      'Success'
    end
  end

  def app_stability_score(app)
    level = app.stability_level
    score_color = app_stability_level(level)
    content_tag :strong, class: "stability-score text-#{score_color}" do
      "#{app.stability_score} %"
    end
  end

  def app_stability_level(level)
    {
      ok:       'success',
      critical: 'danger',
      unstable: 'warning'
    }[level]
  end

  def colors
    { orange: '#f0c75e',
      green:  '#89b94b',
      red:    '#e08f5d' }
  end

  def pie_chart_options
    {
      plotOptions: {
        pie: {
          allowPointSelect: true,
          cursor: 'pointer',
          dataLabels: {
            enabled: false
          },
          showInLegend: true
        }
      }
    }
  end
end
