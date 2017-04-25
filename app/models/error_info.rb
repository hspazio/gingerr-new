class ErrorInfo
  def initialize(error)
    @error = error
    @error_factory = error.class
  end

  def name
    @error.name
  end

  def message
    @error.message
  end

  def file
    @error.file
  end

  def first_seen
    @error_factory.first_seen_by_name(name)
  end

  def last_seen
    @error_factory.last_seen_by_name(name)
  end

  def occurrences
    @error_factory.count_by_name(name)
  end
end
