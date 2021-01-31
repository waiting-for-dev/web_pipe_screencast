# frozen_string_literal: true

require 'web_pipe'
require 'web_pipe/plugs/config'
require 'web_pipe/plugs/content_type'
require 'dry/schema'
require 'dry/monads'
require 'planet_weight/interfaces/html/import'

WebPipe.load_extensions(
  :params,
  :dry_schema,
  :router_params,
  :dry_view)

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
            SCHEMA_FAILURE = lambda do |conn, _result|
              conn
                .set_status(422)
                .set_response_body('Wrong params')
                .halt
            end

            plug :config, WebPipe::Plugs::Config.(
              param_transformations: [:deep_symbolize_keys, :router_params],
              param_sanitization_handler: SCHEMA_FAILURE
            )
            plug :sanitize_params, WebPipe::Plugs::SanitizeParams.(SCHEMA)
            plug :html, WebPipe::Plugs::ContentType.('text/html')
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
