class SignalsController < ApplicationController
  before_action :set_app, only: [:index, :create]
  before_action :set_signal, only: [:show]

  def index
    signals = @app.signals

    respond_to do |format|
      format.json { render json: signals }
    end
  end

  def show
    @error_info = @signal.error? && ErrorInfo.new(@signal.error)
    respond_to do |format|
      format.json { render json: @signal }
      format.html {}
    end
  end

  def create
    creator = SignalCreator.new
    @signal = creator.create(@app, create_params)

    respond_to do |format|
      format.json {
        errors = creator.errors
        if errors.empty?
          render json: @signal, status: :created, location: signal_url(@signal)
        else
          render_errors(errors)
        end
      }
    end
  end

  private

  def set_app
    @app = App.find_by(id: params[:app_id]) || not_found
  end

  def set_signal
    @signal = Signal.includes(:app).find_by(id: params[:id]) || not_found
  end

  def create_params
    params.permit(:type, :pid, :ip, :hostname, :login, error: [
      :name, :message, :file, :backtrace
    ])
  end
end
