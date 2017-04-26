require 'rails_helper'

describe SignalCreator, type: :model do
  before do
    @creator = SignalCreator.new
  end

  it 'creates a success signal given an app and parameters' do
    app = create(:app)
    params = {
      type: 'success',
      pid: 123,
      ip: '123.123.123.123',
      hostname: 'MyHostName',
      login: 'name_surname' }

    signal = @creator.create(app, params)

    expect(signal).to be_kind_of BaseSignal
    expect(signal.errors).to be_empty
    expect(signal.endpoint).to be_kind_of Endpoint
  end

  it 'fails creating success signal if pid not valid' do
    app = create(:app)
    params = {
      type: 'success',
      pid: nil,
      ip: '123.123.123.123',
      hostname: 'MyHostName',
      login: 'name_surname'
    }

    signal = @creator.create(app, params)

    expect(signal).to be_kind_of BaseSignal
    expect(@creator.errors).not_to be_empty
    expect(signal.endpoint.valid?).to be true
  end

  it 'fails creating success signal if invalid endpoint params' do
    app = create(:app)
    params = {
      type: 'success',
      pid: 123,
      ip: '',
      hostname: 'MyHostName',
      login: 'name_surname'
    }

    signal = @creator.create(app, params)

    expect(signal).to be_kind_of BaseSignal
    expect(@creator.errors).not_to be_empty
    expect(signal.endpoint.valid?).to be false
  end

  it 'creates an error signal given an app and parameters' do
    app = create(:app)
    params = {
      type: 'error',
      pid: 123,
      ip: '123.123.123.123',
      hostname: 'MyHostName',
      login: 'name_surname',
      error: {
        name: 'StandarError',
        message: 'something bad happened',
        file: 'file.rb',
        backtrace: "some long\nmultiline backtrace"
      }
    }

    signal = @creator.create(app, params)

    expect(signal).to be_kind_of ErrorSignal
    expect(@creator.errors).to be_empty
    expect(signal.endpoint).to be_kind_of Endpoint
  end

  it 'fails creating an error signal if invalid params' do
    app = create(:app)
    params = {
      type: 'error',
      pid: 123,
      ip: '123.123.123.123',
      hostname: 'MyHostName',
      login: 'name_surname',
      error: {
        name: '',
        message: 'something bad happened',
        file: 'file.rb',
        backtrace: nil
      }
    }

    signal = @creator.create(app, params)

    expect(signal).to be_kind_of ErrorSignal
    expect(@creator.errors).to eq(["Name can't be blank", "Backtrace can't be blank"])
  end
end
