require 'dry/container'
require_relative 'views/weight/show_view'

module PlanetWeight
  Container = Dry::Container.new

  Container.namespace('views') do
    namespace('weight') do
      register('show_view', Weight::ShowView.new)
    end
  end
end
