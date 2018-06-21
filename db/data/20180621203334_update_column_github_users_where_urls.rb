class UpdateColumnGithubUsersWhereUrls < ActiveRecord::Migration[5.2]
  def up
    User.where('github LIKE ?', '%https://github.com/%').each do |user|
      user.update_column(:github, user.github.gsub('https://github.com/', ''))
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
