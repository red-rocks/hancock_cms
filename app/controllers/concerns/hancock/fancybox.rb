module Hancock::Fancybox
  extend ActiveSupport::Concern
  included do
    helper_method :request_for_fancybox?
  end

  def render_for_fancybox
    render layout: false if request_for_fancybox?
  end

  def request_for_fancybox?
    request.xhr? and params[:load_by_fancybox] == "true"
  end
end
