require 'rails_helper'

describe AppStats, type: :model do
  it 'shows not data if app has no signals yet'

  it 'shows charts data for recent signals' do
    app = create(:app)
    create(:success_signal, app: app)
    stats = AppStats.new(app)

    data = stats.recent_signals_timeline

    expect(data.first[:name]).to eq(:error)
    expect(data.last[:name]).to eq(:success)
    data.each do |data_record|
      data_record[:data].each do |date, count|
        expect(date).to be_kind_of(Date)
        expect(count).to be >= 0
      end
    end
  end
end
