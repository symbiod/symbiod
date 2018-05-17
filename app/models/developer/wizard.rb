module Developer
  class Wizard
    attr_reader :developer

    def initialize(developer)
      @developer = developer
    end

    def completed?
      steps.exclude?(developer.state.to_sym)
    end

    def route_for_current_step
      steps_routes_mapping[developer.state.to_sym]
    end

    def steps
      steps_routes_mapping.keys
    end

    private

    def steps_routes_mapping
      {
        pending: 'edit_bootcamp_wizard_profile_url',
        profile_completed: 'bootcamp_wizard_screenings_url',
        screening_completed: 'bootcamp_wizard_screenings_url'
      }
    end
  end
end
