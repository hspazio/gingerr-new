class SignalSerializer < BaseSerializer
  attribute :id
  attribute :state, key: 'type'
  attribute :pid
  attribute :created_at

  belongs_to :app
  belongs_to :endpoint

  has_one :error, serializer: ErrorSerializer, if: :error?

  type 'gingerr/signal'

  def error?
    object.error?
  end
end
