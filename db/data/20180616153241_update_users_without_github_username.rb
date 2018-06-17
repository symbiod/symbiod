class UpdateUsersWithoutGithubUsername < ActiveRecord::Migration[5.2]
  def up
    github_service = GithubService.new(ENV['GITHUB_TOKEN'], 'howtohireme')
    User.where(github: ['', nil]).each do |user|
      request = github_service.search_users(user.email)
      user.update!(github: request[:items].first[:login]) if (request[:total_count]).positive?
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
