class ApplicationController < ActionController::Base
  include Pagy::Method
  include RequestContext
  include Authentication

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  protected

  def pagination_request(query_params)
    unless query_params.is_a?(ActionController::Parameters) && query_params.permitted?
      raise ArgumentError, "pagination params must be explicitly permitted"
    end

    {
      base_url: request.base_url,
      path: request.path,
      params: query_params.to_h,
      cookie: nil
    }
  end
end
