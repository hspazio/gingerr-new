require 'rails_helper'

describe ErrorSignal, type: :model do
  it 'has an error object collaborator' do
    signal = create(:error_signal)
    error = create(:error, signal: signal)

    expect(signal.error).to eq(error)
  end
end

