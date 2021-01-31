# frozen_string_literal: true

require_relative 'planet_weight/core/container'
require 'bundler'
Bundler.setup(:core, :default)

PlanetWeight::Core::Container.finalize!

