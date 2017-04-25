class AppSerializer < BaseSerializer
  attributes :id, :name, :created_at, :updated_at

  has_many :recent_signals
end
