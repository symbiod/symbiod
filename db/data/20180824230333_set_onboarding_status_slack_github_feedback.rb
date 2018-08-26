class SetOnboardingStatusSlackGithubFeedback < ActiveRecord::Migration[5.2]
  def up
    Member::Onboarding.all.each do |onboarding|
      onboarding.update(github_status: 'github_invited', slack_status: 'slack_invited')
    end
    Member::Onboarding::SurveyResponse.all.each do |feedback|
      feedback.newcomer.developer_onboarding.update(feedback_status: 'feedback_completed')
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
