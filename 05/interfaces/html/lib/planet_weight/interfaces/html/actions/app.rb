# frozen_string_literal: true

require 'web_pipe'
require 'web_pipe/plugs/config'
require 'web_pipe/plugs/content_type'
require 'rack/runtime'

WebPipe.load_extensions(
  :params,
  :dry_schema,
  :router_params,
  :dry_view)

module PlanetWeight
  module Interfaces
    module Html
      class App
        include WebPipe

        SCHEMA_FAILURE = lambda do |conn, _result|
          conn
            .set_status(422)
            .set_response_body('Wrong params')
            .halt
        end

        use :runtime, Rack::Runtime

        plug :config, WebPipe::Plugs::Config.(
          param_transformations: [:deep_symbolize_keys, :router_params],
          param_sanitization_handler: SCHEMA_FAILURE
        )
        plug :html, WebPipe::Plugs::ContentType.('text/html')
      end
    end
  end
end
