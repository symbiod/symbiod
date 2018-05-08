# frozen_string_literal: true

# Provides methods for dealing with multidomain url helpers
module SubdomainUrlHelper
  def nav_link(title, url, subdomain: 'www', id: '')
    is_active = request.subdomains.include?(subdomain)
    link_to title, url, class: "nav-link #{is_active ? 'active' : ''}", id: id
  end

  def root_landing_url
    root_url(subdomain: 'www')
  end
end
