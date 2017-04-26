require 'rails_helper'

describe App, type: :model do
  context 'name' do
    it 'is not valid if nil' do
      app = build(:app, name: nil)
      expect(app).to have_errors_for :name
    end

    it 'is not valid if empty' do
      app = build(:app, name: '')
      expect(app).to have_errors_for :name
    end

    it 'is valid if present' do
      app = build(:app, name: 'example app')
      expect(app).not_to have_errors_for :name
    end
  end

  it 'has recent_signals' do
    app = create(:app)
    signals = create_list(:success_signal, 3, app: app)

    result = app.recent_signals(2)

    expect(result).to eq(signals[1..-1].reverse)
  end

  it 'has current_signals' do
    app = create(:app)
    signals = create_list(:success_signal, 2, app: app)

    result = app.current_signal

    expect(result).to eq(signals.last)
  end

  it 'has current_signal_state' do
    app = create(:app)
    create_list(:success_signal, 2, app: app)

    expect(app.current_signal_state).to eq(:success)
  end

  it 'has current_signal_created_at' do
    app = create(:app)
    signal = create(:success_signal, app: app)

    expect(app.current_signal_created_at).to eq(signal.created_at)
  end

  it 'calculates approximate signal frequency' do
    app = build(:app, signal_frequency: 10_000)
    expect(app.signal_frequency_in_hours).to eq('2 sig/h')

    app.signal_frequency = 20_000
    expect(app.signal_frequency_in_hours).to eq('5 sig/h')
  end

  context '#stability_level' do
    it 'is :ok if 100% stability score' do
      app = build(:app, stability_score: 100)
      expect(app.stability_level).to eq(:ok)
    end

    it 'is :unstable if stability score not high enough' do
      app = build(:app, stability_score: 71)
      expect(app.stability_level).to eq(:unstable)

      app = build(:app, stability_score: 99)
      expect(app.stability_level).to eq(:unstable)
    end

    it 'is :critical if stability score is low' do
      app = build(:app, stability_score: 20)
      expect(app.stability_level).to eq(:critical)

      app = build(:app, stability_score: 0)
      expect(app.stability_level).to eq(:critical)

      app = build(:app, stability_score: 70)
      expect(app.stability_level).to eq(:critical)
    end
  end
end

