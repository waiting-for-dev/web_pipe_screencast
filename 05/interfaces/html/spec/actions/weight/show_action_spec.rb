# frozen_string_literal: true

require 'planet_weight/interfaces/html/actions/weight/show_action'
require 'planet_weight/interfaces/html/router'
require 'web_pipe/test_support'
require 'rack/mock'

RSpec.describe PlanetWeight::Interfaces::Html::Actions::Weight::ShowAction do
  include WebPipe::TestSupport

  context 'when planet is not known' do
    it 'responds with 404 status' do
      env = Rack::MockRequest.env_for('https://example.org/weight_on/not_known/50')

      status, _header, _body = PlanetWeight::Interfaces::Html::Router.(env)

      expect(status).to be(404)
    end 

    it 'responds with 404 status' do
      calculate = described_class.new.operations[:calculate]
      conn = build_conn
              .add(:weight, 50)
              .add(:planet, 'not_known')

      new_conn = calculate.(conn)

      expect(new_conn.status).to be(404)
    end 
  end
end
