require 'rails_helper'

describe Stats, type: :model do
  context 'AppStateSummary' do
    it 'shows a breakdown of the state of each app'
      # App.any_instance.stubs(stability_level: :ok, stability_score: 0)
      # project_health = Stats::AppsStateSummary.new(App.all)
      # data = project_health.call

      # expected_data = [
      #   [:ok, 3],
      #   [:unstable, 0],
      #   [:critical, 0]
      # ]

      # assert_equal expected_data, data
  end
end
