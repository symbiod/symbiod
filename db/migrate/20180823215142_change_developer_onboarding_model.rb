class ChangeDeveloperOnboardingModel < ActiveRecord::Migration[5.2]
  def up
    add_column :developer_onboardings, :feedback_status, :string
    add_column :developer_onboardings, :slack_status, :string
    add_column :developer_onboardings, :github_status, :string
    safety_assured { remove_column :developer_onboardings, :slack }
    safety_assured { remove_column :developer_onboardings, :github }
  end

  def down
    add_column :developer_onboardings, :slack, :boolean
    change_column_default :developer_onboardings, :slack, false
    add_column :developer_onboardings, :github, :boolean
    change_column_default :developer_onboardings, :github, false
    remove_column :developer_onboardings, :slack_status
    remove_column :developer_onboardings, :github_status
    remove_column :developer_onboardings, :feedback_status
  end
end
