# frozen_string_literal: true

require 'web_pipe'
require 'bundler/setup'
require 'web_pipe/plugs/config'
require 'web_pipe/plugs/content_type'
require 'dry/schema'
require 'hanami/router'
require_relative 'lib/planet_weight/views/weight/show_view'
require_relative 'lib/planet_weight/container'

WebPipe.load_extensions(
  :params,
  :dry_schema,
  :router_params,
  :dry_view,
  :container)

module PlanetWeight
  module Weight
    class Show
      include WebPipe

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
        param_sanitization_handler: SCHEMA_FAILURE,
        container: Container
      )
      plug :sanitize_params, WebPipe::Plugs::SanitizeParams.(SCHEMA)
      plug :html, WebPipe::Plugs::ContentType.('text/html')
      plug :fetch_params
      plug :fetch_factor
      plug :calculate
      plug :render

      private

      def fetch_params(conn)
        conn
          .add(:weight, conn.sanitized_params[:weight])
          .add(:planet, conn.sanitized_params[:planet])
      end

      def fetch_factor(conn)
        factor = FACTORS[conn.fetch(:planet)]
        if factor
          conn.add(:factor, factor)
        else
          conn
            .set_status(404)
            .set_response_body('Data not found for given star')
            .halt
        end
      end

      def calculate(conn)
        conn
          .add(:planet_weight, conn.fetch(:weight) * conn.fetch(:factor))
      end

      def render(conn)
        conn
          .view(
            'views.weight.show_view',
            weight: conn.fetch(:weight),
            planet: conn.fetch(:planet),
            planet_weight: conn.fetch(:planet_weight)
          )
      end
    end
  end
end

App = Hanami::Router.new do
  get '/weight_on/:planet/:weight', to: PlanetWeight::Weight::Show.new
end

run App
