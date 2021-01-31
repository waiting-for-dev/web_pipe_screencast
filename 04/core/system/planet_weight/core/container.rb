# frozen_string_literal: true

require 'dry/system/container'

module PlanetWeight
  module Core
    class Container < Dry::System::Container
      configure do
        config.name = :core
        config.root = Pathname(__FILE__).dirname.join('../../../')
        config.default_namespace = 'planet_weight.core'
        config.auto_register = 'lib'
      end

      load_paths!('lib')
    end
  end
end
