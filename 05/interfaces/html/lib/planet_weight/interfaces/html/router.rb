# frozen_string_literal: true

require 'hanami/router'
require 'planet_weight/interfaces/html/container'

module PlanetWeight
  module Interfaces
    module Html
      Router = Hanami::Router.new do
        get '/weight_on/:planet/:weight', to: Container['actions.weight.show_action']
      end
    end
  end
end

