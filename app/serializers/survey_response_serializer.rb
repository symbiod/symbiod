# frozen_string_literal: true

# Serialize feedback questions
class SurveyResponseSerializer
  def self.dump(hash)
    hash.to_json
  end

  def self.load(hash)
    hash = JSON.parse(hash) if hash.is_a?(String)
    (hash || {}).with_indifferent_access
  end
end
