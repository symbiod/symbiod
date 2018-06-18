class UpdateUsersWithoutGithubUsername < ActiveRecord::Migration[5.2]
  def up
    github_service = GithubService.new(ENV['GITHUB_TOKEN'], 'howtohireme')
    User.where(github: ['', nil]).each do |user|
      user.update_column(:github, github_service.username_by_email(user.email))
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
