# frozen_string_literal: true

require 'dry/system/container'

module PlanetWeight
  module Interfaces
    module Cli
      class Container < Dry::System::Container
        configure do
          config.name = :cli
          config.root = Pathname(__FILE__).dirname.join('../../../../')
          config.default_namespace = 'planet_weight.interfaces.cli'
          config.auto_register = 'lib'
        end

        require_relative root.join('../../core/system/boot')
        import core: PlanetWeight::Core::Container

        load_paths!('lib')
      end
    end
  end
end
