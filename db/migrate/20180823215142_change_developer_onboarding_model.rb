class ChangeDeveloperOnboardingModel < ActiveRecord::Migration[5.2]
  def up
    add_column :developer_onboardings, :feedback_completed, :boolean
    change_column_default :developer_onboardings, :feedback_completed, false
    add_column :developer_onboardings, :slack_completed, :boolean
    change_column_default :developer_onboardings, :slack_completed, false
    add_column :developer_onboardings, :github_completed, :boolean
    change_column_default :developer_onboardings, :github_completed, false
    safety_assured { remove_column :developer_onboardings, :slack }
    safety_assured { remove_column :developer_onboardings, :github }
  end

  def down
    add_column :developer_onboardings, :slack, :boolean
    change_column_default :developer_onboardings, :slack, false
    add_column :developer_onboardings, :github, :boolean
    change_column_default :developer_onboardings, :github, false
    remove_column :developer_onboardings, :slack_completed
    remove_column :developer_onboardings, :github_completed
    remove_column :developer_onboardings, :feedback_completed
  end
end
