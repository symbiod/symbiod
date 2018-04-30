# frozen_string_literal: true

# Provides methods for dealing with multidomain url helpers
module SubdomainUrlHelper
  def nav_link(title, url, subdomain: 'www')
    is_active = request.subdomains.include?(subdomain)
    link_to title, url, class: "nav-link #{is_active ? 'active' : ''}"
  end
end
