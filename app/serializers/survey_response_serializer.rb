# frozen_string_literal: true

# Serialize feedback questions
class SurveyResponseSerializer
  # This method converts hash to string before saving object in bd
  def self.dump(hash)
    hash.to_json
  end

  # This metod converts string or hash to JSON format when load record from db
  def self.load(hash)
    hash = JSON.parse(hash) if hash.is_a?(String)
    (hash || {}).with_indifferent_access
  end
end
