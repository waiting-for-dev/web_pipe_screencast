# frozen_string_literal: true

require 'dry/view'

module PlanetWeight
  module Interfaces
    module Html
      module Views
        class AppView < Dry::View
          config.paths = [File.join(__dir__, '../templates')]
          config.layout = 'application'
        end
      end
    end
  end
end
