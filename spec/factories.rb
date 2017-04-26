FactoryGirl.define do
  factory :app, class: 'App' do
    sequence(:name){ |n| "example app #{n}" }

    after(:stub) do |app, evaluator|
      #app.signals = [build_stubbed(:error_signal, app: app),
      #build_stubbed(:success_signal, app: app)]
    end
  end

  factory :signal, class: 'BaseSignal' do
    sequence(:pid){ |n| n }

    association :app
    association :endpoint

    factory :success_signal, class: 'SuccessSignal' do
      type 'SuccessSignal'
    end

    factory :error_signal, class: 'ErrorSignal' do
      type 'ErrorSignal'
      #association :error
    end
  end

  factory :endpoint, class: 'Endpoint' do
    ip { generate :ip }
    sequence(:hostname){ |n| "hostname#{n}" }
    sequence(:login)   { |n| "login#{n}" }
  end

  factory :error, class: 'Error' do
    sequence(:name) { |n| "ErrorClass#{n}" }
    sequence(:message) { |n| "message#{n}" }
    sequence(:file) { |n| "file#{n}" }
    backtrace <<-BACKTRACE
from /gingerr/test/test_helper.rb:27:in `<top (required)>'
from /gingerr/test/charts/gingerr/distance_between_signals_test.rb:1:in `require'
from /gingerr/test/charts/gingerr/distance_between_signals_test.rb:1:in `<top (required)>'
BACKTRACE

    association :signal, factory: :error_signal
  end

  sequence :ip do |_|
    4.times.map { rand(255) }.join('.')
  end
end
