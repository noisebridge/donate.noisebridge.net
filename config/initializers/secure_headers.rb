SecureHeaders::Configuration.default do |config|
  config.hsts = "max-age=#{20.years.to_i}"
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.csp = {
    # "meta" values. these will shaped the header, but the values are not included in the header.
    report_only:  true,     # default: false
    preserve_schemes: true, # default: false. Schemes are removed from host sources to save bytes and discourage mixed content.

    # directive values: these values will directly translate into source directives
    default_src: %w(https: 'self'),
    frame_src: %w('self'),
    connect_src: %w(wws:),
    font_src: %w('self' fonts.gstatic.com fonts.googleapis.com),
    img_src: %w('self'),
    media_src: %w('self'),
    object_src: %w('self'),
    script_src: %w('self' js.stripe.com),
    style_src: %w('unsafe-inline'),
    base_uri: %w('self'),
    child_src: %w('self'),
    form_action: %w('self' github.com),
    frame_ancestors: %w('none'),
    plugin_types: %w(application/x-shockwave-flash),
    block_all_mixed_content: true, # see [http://www.w3.org/TR/mixed-content/](http://www.w3.org/TR/mixed-content/)
    report_uri: %w(https://app.getsentry.com/api/68953/csp-report?sentry_version=5&sentry_key=e03db32ca8b543ffbf797c534d173035)
  }
end
