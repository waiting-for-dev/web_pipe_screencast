# frozen_string_literal: true

require 'dry/view'

module PlanetWeight
  class AppView < Dry::View
    config.paths = [File.join(__dir__, '../templates')]
    config.layout = 'application'
  end
end
