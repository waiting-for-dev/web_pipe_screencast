# frozen_string_literal: true

require_relative 'planet_weight/interfaces/cli/container'
require 'bundler'
Bundler.setup(:cli, :default)

PlanetWeight::Interfaces::Cli::Container.finalize!
