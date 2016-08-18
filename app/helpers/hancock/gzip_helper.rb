module Hancock::GzipHelper
  def gzip_javascript_include_tag(*sources)
    # Grab the asset html include tag
    tag = javascript_include_tag(*sources)

    # If we are in production and the requesting client accepts gzip encoding, swap for the gzip asset
    if Rails.env.production? && request.accept_encoding =~ /gzip/i
      tag = tag.gsub(/\.js/i, ".js.gz")
    end

    # Return the asset whether or not it was modified
    tag.html_safe
  end

  def gzip_stylesheet_link_tag(*sources)
    # Grab the asset html include tag
    tag = stylesheet_link_tag(*sources)

    # If we are in production and the requesting client accepts gzip encoding, swap for the gzip asset
    if Rails.env.production? && request.accept_encoding =~ /gzip/i
      tag = tag.gsub(/\.css/i, ".css.gz")
    end

    # Return the asset whether or not it was modified
    tag.html_safe
  end
end
