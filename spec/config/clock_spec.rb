require "clockwork/test"

describe Clockwork do
  after(:each) { Clockwork::Test.clear! }

  # it "runs the job once" do
  #   Clockwork::Test.run(max_ticks: 1)

  #   expect(Clockwork::Test.ran_job?("SendFollowupJob")).to be_truthy
  #   expect(Clockwork::Test.times_run("SendFollowupJob")).to eq 1
  # end

  # it "runs the job every minute over the course of an hour" do
  #   start_time = Time.new(2018, 01, 1, 2, 0, 0)
  #   end_time = Time.new(2018, 12, 31, 3, 0, 0)

  #   Clockwork::Test.run(start_time: start_time, end_time: end_time, tick_speed: 3.days)

  #   expect(Clockwork::Test.times_run("SendFollowupJob")).to eq 60
  # end

  # describe "RSpec Custom Matcher" do
  #   subject(:clockwork) { Clockwork::Test }

  #   before { Clockwork::Test.run(max_ticks: 1) }

  #   it { should have_run("SendFollowupJob") }
  #   it { should have_run("SendFollowupJob").once }

  #   it { should_not have_run("SendFollowupJob").exactly(2).times }
  # end
end