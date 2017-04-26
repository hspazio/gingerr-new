require 'rails_helper'

describe BaseSignal, type: :model do
  it 'returns STI class for provided type' do
    expect(BaseSignal.class_for_type(:success)).to eq('SuccessSignal')
    expect(BaseSignal.class_for_type(:error)).to eq('ErrorSignal')
  end

  context 'type' do
    it 'is not valid if type is not present' do
      signal = build(:success_signal, type: nil)
      expect(signal).to have_errors_for :type
    end

    it 'is not valid if type is not supported' do
      signal = build(:success_signal, type: 'UnknownType')
      expect(signal).to have_errors_for :type
    end

    it 'is valid if type is ErrorSignal' do
      signal = build(:error_signal)
      expect(signal).not_to have_errors_for :type
    end
  end

  context 'PID' do
    it 'is not valid if PID is not present' do
      signal = build(:error_signal, pid: nil)
      expect(signal).to have_errors_for :pid
    end

    it 'is not valid if PID is string' do
      signal = build(:success_signal, pid: '')
      expect(signal).to have_errors_for :pid
    end

    it 'is not valid if PID is zero' do
      signal = build(:success_signal, pid: 0)
      expect(signal).to have_errors_for :pid
    end

    it 'is valid if PID is numeric non zero' do
      signal = build(:error_signal, pid: 123)
      expect(signal).not_to have_errors_for :pid
    end
  end

  it 'is not valid if not belonging to an app' do
    signal = build(:success_signal, app: nil)
    expect(signal).to have_errors_for :app
  end

  it 'is not valid if not belonging to an endpoint' do
    signal = build(:error_signal, endpoint: nil)
    expect(signal).to have_errors_for :endpoint
  end

  it 'responds to app_name' do
    signal = build(:success_signal, app: build(:app, name: 'test app'))
    expect(signal.app_name).to eq('test app')
  end

  it 'returns true to ErrorSignal#error?' do
    signal = ErrorSignal.new
    expect(signal.error?).to be true
  end

  it 'returns false to SuccessSignal#error?' do
    signal = SuccessSignal.new
    expect(signal.error?).to be false
  end

  it 'responds to state' do
    error_signal = ErrorSignal.new
    success_signal = SuccessSignal.new

    expect(error_signal.state).to eq(:error)
    expect(success_signal.state).to eq(:success)
  end

  it 'delegates endpoint description to endpoint' do
    endpoint = build(:endpoint, ip: '123.123.123.123', login: 'login', hostname: 'hostname')
    signal = build(:success_signal, endpoint: endpoint)

    expect(signal.endpoint_description).to eq('login@hostname (123.123.123.123)')
  end

  it 'triggers caching of app stats when new signal is created' do
    app = create(:app, stability_score: 23, signal_frequency: 123456)
    create(:success_signal, app: app)

    expect(app.stability_score).not_to eq(23)
    expect(app.signal_frequency).not_to eq(123456)
  end
end
