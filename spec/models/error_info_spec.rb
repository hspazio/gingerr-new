require 'rails_helper'

describe ErrorInfo, type: :model do
  it 'decorates an error object' do
    error = Error.new(
      name: 'the-error',
      message: 'the-message',
      file: 'the-file',
    )
    first_seen_date = Date.new(2017, 3, 25)
    last_seen_date  = Date.new(2017, 4, 11)
    allow(Error).to receive(:first_seen_by_name).with('the-error').and_return(first_seen_date)
    allow(Error).to receive(:last_seen_by_name).with('the-error').and_return(last_seen_date)
    allow(Error).to receive(:count_by_name).with('the-error').and_return(17)

    error_info = ErrorInfo.new(error)

    expect(error_info.name).to eq('the-error')
    expect(error_info.message).to eq('the-message')
    expect(error_info.first_seen).to eq(first_seen_date)
    expect(error_info.last_seen).to eq(last_seen_date)
    expect(error_info.occurrences).to eq(17)
  end
end
