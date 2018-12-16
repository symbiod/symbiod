# frozen_string_literal: true

# Provides methods for dealing with multidomain url helpers
module SubdomainUrlHelper
  def nav_link(title, url, slug: nil, id: '')
    is_active = request.url.split('/')[3] == slug
    link_to title, url, class: "nav-link #{is_active ? 'active' : ''}", id: id
  end
end
