module ApplicationHelper
  def current_version
    if Rails.env.production?
      # TODO: Replace this with a suitable environment variable
      Dir.pwd.match(/noisebridge-donate-([0-9a-f]{40})/)[1]
    else
      "development"
    end
  end
end
