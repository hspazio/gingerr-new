class ErrorSerializer < BaseSerializer
  attributes :name, :message, :file, :backtrace

  def backtrace
    object.backtrace.lines
  end
end
