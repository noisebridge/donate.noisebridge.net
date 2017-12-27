module ApplicationHelper
  GITHUB_URL = "https://github.com/patrickod/noisebridge-donate".freeze
  LICENSE_URL = "https://gnu.org/licenses/agpl.html".freeze
  BITCOIN_ADDRESS = "1NrbWrxkdPuyPfFtc1W4AKNtkQMyXwAAJV".freeze

  def license_link
    link_to("AGPL V3", LICENSE_URL)
  end

  def github_link
    link_to("donate.noisebridge.net", root_url)
  end

  def bitcoin_link
    link_to(BITCOIN_ADDRESS, "bitcoin:#{BITCOIN_ADDRESS}")
  end

  def current_version_link
    link_to(current_version, current_version_github_url)
  end

  def current_version
    if Rails.env.production?
      # TODO: Replace this with a suitable environment variable
      Dir.pwd.match(/noisebridge-donate-([0-9a-f]{40})/)[1]
    else
      "development"
    end
  end

  def current_version_github_url
    if Rails.env.production?
      "#{GITHUB_URL}/commits/#{current_version}"
    else
      "#"
    end
  end
end
