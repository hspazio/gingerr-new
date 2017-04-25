class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: proc { |c| c.request.format.to_s == 'application/json' }

  before_action :authenticate

  def dashboard
    @apps = App.listing
    @project_health = Stats::AppsStateSummary.new(@apps).call
    @recent_errors = Stats::RecentErrors.new.call
    @signals = BaseSignal.recent.includes(:app, :endpoint)
  end

  def render_errors(errors, status = :bad_request)
    render json: { errors: errors }, status: status
  end

  def not_found
    respond_to do |format|
      format.json { render_errors(['Record not found'], :not_found) }
      format.html {}
    end
  end

  def authenticate
    if request.format.to_s == 'application/json' 
      # authenticate using access token
    else 
      if authenticate_with_http_basic { |u, p| u == 'admin' && p == 'admin' }

      else
        request_http_basic_authentication
      end
    end
  end
end
