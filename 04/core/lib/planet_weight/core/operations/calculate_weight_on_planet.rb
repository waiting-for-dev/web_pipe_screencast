# frozen_string_literal: true

require 'dry/monads'

module PlanetWeight
  module Core
    module Operations
      class CalculateWeightOnPlanet
        include Dry::Monads[:maybe]

        FACTORS = {
          mercury: 0.38,
          venus: 0.91,
          earth: 1,
          mars: 0.38,
          jupiter: 2.34,
          saturn: 1.06,
          uranus: 0.92,
          neptune: 1.19
        }.freeze

        def call(weight, planet)
          factor = FACTORS[planet]
          if factor
            Some(weight * factor)
          else
            None()
          end
        end
      end
    end
  end
end
