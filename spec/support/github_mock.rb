# frozen_string_literal: true

# Provides mocks for Github API
module GithubMock
  def github_response_template
    stub_request(:get, 'https://api.github.com/search/users?q=opensource@howtohireme.ru')
      .with(headers: {
              'Accept' => 'application/vnd.github.v3+json',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type' => 'application/json',
              'User-Agent' => 'Octokit Ruby Gem 4.8.0'
            })
      .to_return(status: 200, body: '', headers: {})
  end
end
