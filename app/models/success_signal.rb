class SuccessSignal < BaseSignal
  def error?
    false
  end

  def success?
    true
  end
end
