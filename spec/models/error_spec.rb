require 'rails_helper'

describe Error, type: :model do
  it '.first_seen_by_name' do
    signal = create(:error_signal)
    create(:error, created_at: 1.day.ago.to_date,  name: 'the-error', signal: signal)
    create(:error, created_at: 2.days.ago.to_date, name: 'the-error', signal: signal)

    result = Error.first_seen_by_name('the-error')

    expect(result).to eq(2.days.ago.to_date)
  end

  it '.last_seen_by_name' do
    signal = create(:error_signal)
    create(:error, created_at: 1.day.ago.to_date,  name: 'the-error', signal: signal)
    create(:error, created_at: 2.days.ago.to_date, name: 'the-error', signal: signal)

    result = Error.last_seen_by_name('the-error')

    expect(result).to eq(1.day.ago.to_date)
  end

  it '.count_by_name' do
    signal = create(:error_signal)
    create(:error, name: 'the-error', signal: signal)
    create(:error, name: 'the-error', signal: signal)

    result = Error.count_by_name('the-error')

    expect(result).to eq(2)
  end

  it 'is not valid if name not present' do
    error = build(:error, name: nil)
    expect(error).to have_errors_for :name

    error.name = ''
    expect(error).to have_errors_for :name
  end

  it 'is not valid if message not present' do
    error = build(:error, message: nil)
    expect(error).to have_errors_for :message

    error.message = ''
    expect(error).to have_errors_for :message
  end

  it 'is not valid if file not present' do
    error = build(:error, file: nil)
    expect(error).to have_errors_for :file

    error.file = ''
    expect(error).to have_errors_for :file
  end

  it 'is not valid if backtrace not present' do
    error = build(:error, backtrace: nil)
    expect(error).to have_errors_for :backtrace

    error.backtrace = ''
    expect(error).to have_errors_for :backtrace
  end
end


