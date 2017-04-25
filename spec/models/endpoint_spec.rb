require 'rails_helper'

RSpec.describe Endpoint, type: :model do
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
end
