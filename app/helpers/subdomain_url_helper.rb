# frozen_string_literal: true

# Provides methods for dealing with multidomain url helpers
module SubdomainUrlHelper
  def nav_link(title, url, subdomain: 'www', id: '')
    # TODO: remake to check the url instead of subdomain
    is_active = request.subdomains.include?(subdomain)
    link_to title, url, class: "nav-link #{is_active ? 'active' : ''}", id: id
  end
end
