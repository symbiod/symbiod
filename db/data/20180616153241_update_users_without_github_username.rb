class UpdateUsersWithoutGithubUsername < ActiveRecord::Migration[5.2]
  def up
    User.where(github: ['', nil]).each do |user|
      request = JSON.parse(open("https://api.github.com/search/users?q=#{user.email}+in%3Aemail").read)
      user.update!(github: request['items'].first['login']) if (request['total_count']).positive?
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
