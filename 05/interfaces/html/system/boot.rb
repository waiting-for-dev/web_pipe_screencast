# frozen_string_literal: true

require_relative 'planet_weight/interfaces/html/container'
require 'bundler'
Bundler.setup(:html, :default)

PlanetWeight::Interfaces::Html::Container.finalize!
