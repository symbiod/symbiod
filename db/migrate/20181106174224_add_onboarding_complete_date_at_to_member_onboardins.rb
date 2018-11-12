class AddOnboardingCompleteDateAtToMemberOnboardins < ActiveRecord::Migration[5.2]
  def up
    add_column :member_onboardings, :onboarding_complete_date_at, :datetime
    change_column_default :member_onboardings, :onboarding_complete_date_at, -> { 'CURRENT_TIMESTAMP' }
    Member::Onboarding.find_each do |member|
      member.update_column(:onboarding_complete_date_at, member.updated_at)
    end
  end

  def down
    remove_column :member_onboardings, :onboarding_complete_date_at
  end
end
