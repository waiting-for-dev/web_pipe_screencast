# frozen_string_literal: true

require_relative '../app_view'

module PlanetWeight
  module Weight
    class ShowView < AppView
      config.template = 'weight/show'

      expose :weight
      expose(:planet) { |planet:| planet.capitalize }
      expose(:planet_weight) { |planet_weight:| planet_weight.to_i }
    end
  end
end
