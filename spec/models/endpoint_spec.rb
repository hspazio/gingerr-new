require 'rails_helper'

describe Endpoint, type: :model do
  before do
    @endpoint = Endpoint.new
  end

  context 'ip' do
    it 'is not valid if nil' do
      @endpoint.ip = nil
      expect(@endpoint).to have_errors_for :ip
    end

    it 'is not valid if empty' do
      @endpoint.ip = ''
      expect(@endpoint).to have_errors_for :ip
    end

    it 'is not valid if not IPv4 format' do
      @endpoint.ip = '1.hello.1.x'
      expect(@endpoint).to have_errors_for :ip

      @endpoint.ip = '1.144.555.666'
      expect(@endpoint).to have_errors_for :ip
    end

    it 'has a valid IPv4 format' do
      @endpoint.ip = '1.144.123.255'
      expect(@endpoint).not_to have_errors_for :ip
    end
  end

  context 'hostname' do
    it 'is not valid if nil' do
      @endpoint.hostname = nil
      expect(@endpoint).to have_errors_for :hostname
    end

    it 'is not valid if empty' do
      @endpoint.hostname = ''
      expect(@endpoint).to have_errors_for :hostname
    end

    it 'is valid if present' do
      @endpoint.hostname = 'my-host-name'
      expect(@endpoint).not_to have_errors_for :hostname
    end
  end

  context 'login' do
    it 'is not valid if nil' do
      @endpoint.login = nil
      expect(@endpoint).to have_errors_for :login
    end

    it 'is not valid if empty' do
      @endpoint.login = ''
      expect(@endpoint).to have_errors_for :login
    end

    it 'is valid if present' do
      @endpoint.login = 'my_login'
      expect(@endpoint).not_to have_errors_for :login
    end
  end

  context '#from_params' do
    it 'creates new endpoint from params' do
      endpoint = Endpoint.from_params(
        ip: '123.123.123.123',
        hostname: 'myhost',
        login: 'mylogin'
      )

      expect(endpoint).to be_valid
    end

    it 'returns existing endpoint if exists' do
      existing_endpoint = create(:endpoint)
      endpoint = Endpoint.from_params(
        ip: existing_endpoint.ip,
        hostname: existing_endpoint.hostname,
        login: existing_endpoint.login
      )

      expect(endpoint).to eq(existing_endpoint)
    end
  end
end
