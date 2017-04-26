class SignalCreator
  attr_reader :errors

  def initialize
    @errors = []
  end

  def create(app, params)
    if params[:type]
      signal_params = { pid: params[:pid], type: BaseSignal.class_for_type(params[:type]) }

      BaseSignal.transaction do
        endpoint = Endpoint.from_params(params.slice(:ip, :hostname, :login))
        @errors += endpoint.errors.full_messages unless endpoint.persisted?

        signal = app.signals.create(signal_params.merge(endpoint: endpoint))
        @errors += signal.errors.full_messages unless signal.persisted?

        if signal.respond_to?(:error?) && signal.error?
          error = signal.create_error(params[:error])
          @errors += error.errors.full_messages unless error.persisted?
        end

        signal
      end
    else
      @errors << 'Missing parameter \'type\''
      app.signals.build
    end
  end
end
