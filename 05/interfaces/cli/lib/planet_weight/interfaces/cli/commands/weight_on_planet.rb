# frozen_string_literal: true

require 'dry/cli'
require 'planet_weight/interfaces/cli/import'
require 'dry/monads'
require 'dry/schema'

module PlanetWeight
  module Interfaces
    module Cli
      module Commands
        extend Dry::CLI::Registry

        class WeightOnPlanet < Dry::CLI::Command
          include Import['core.operations.calculate_weight_on_planet'] 
          include Dry::Monads[:maybe]

          SCHEMA = Dry::Schema.Params do
            required(:weight).filled(:integer)
            required(:planet).filled(:symbol)
          end

          desc 'Returns your weight on another planet'
          argument :weight, required: true, desc: 'Your weight'
          argument :planet, required: true, desc: 'The planet'

          def call(weight:, planet:)
            input = SCHEMA.(weight: weight, planet: planet).output 
            result = calculate_weight_on_planet.(input[:weight], input[:planet])
            case result
              in None
                puts "Planet #{input[:planet]} not known"
              in Some(planet_weight)
                puts "Your weight on #{input[:planet]} would be #{planet_weight}"
            end
          end
        end

        register 'weight_on_planet', WeightOnPlanet
      end

      Dry::CLI.new(Commands).call
    end
  end
end
