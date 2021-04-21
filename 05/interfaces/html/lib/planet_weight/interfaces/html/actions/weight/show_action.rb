# frozen_string_literal: true

require 'web_pipe'
require 'dry/schema'
require 'dry/monads'
require 'planet_weight/interfaces/html/import'
require 'planet_weight/interfaces/html/actions/app'

module PlanetWeight
  module Interfaces
    module Html
      module Actions
        module Weight
          class ShowAction
            include WebPipe
            include Dry::Monads[:maybe]
            include Import[
              'core.operations.calculate_weight_on_planet',
              'views.weight.show_view'
            ]

            SCHEMA = Dry::Schema.Params do
              required(:weight).filled(:integer)
              required(:planet).filled(:symbol)
            end

            compose :app, App.new

            plug :sanitize_params, WebPipe::Plugs::SanitizeParams.(SCHEMA)
            plug :fetch_params
            plug :calculate
            plug :render

            private

            def fetch_params(conn)
              conn
                .add(:weight, conn.sanitized_params[:weight])
                .add(:planet, conn.sanitized_params[:planet])
            end

            def calculate(conn)
              result = calculate_weight_on_planet.(
                conn.fetch(:weight), conn.fetch(:planet)
              )
              case result
                in None
                conn
                  .set_status(404)
                  .set_response_body('Data not found for given star')
                  .halt
                in Some(planet_weight)
                conn
                  .add(:planet_weight, planet_weight)
              end
            end

            def render(conn)
              conn
                .view(
                  show_view,
                  weight: conn.fetch(:weight),
                  planet: conn.fetch(:planet),
                  planet_weight: conn.fetch(:planet_weight)
                )
            end
          end
        end
      end
    end
  end
end
