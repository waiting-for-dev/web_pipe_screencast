# frozen_string_literal: true

require 'web_pipe'

class App
  include WebPipe

  FACTORS = {
    mercury: 0.38,
    venus: 0.91,
    earth: 1,
    mars: 0.38,
    jupiter: 2.34,
    saturn: 1.06,
    uranus: 0.92,
    neptune: 1.19
  }.freeze

  plug :html
  plug :fetch_params
  plug :fetch_factor
  plug :calculate
  plug :render

  private

  def html(conn)
    conn
      .add_response_header('Content-Type', 'text/html')
  end

  def fetch_params(conn)
    conn
      .add(:weight, conn.query_string.match(/weight=(\d+)/)[1].to_i)
      .add(:planet, conn.query_string.match(/planet=(\w+)/)[1].to_sym)
  end

  def fetch_factor(conn)
    factor = FACTORS[conn.fetch(:planet)]
    if factor
      conn.add(:factor, factor)
    else
      conn
        .set_status(404)
        .set_response_body('Data not found for given star')
        .halt
    end
  end

  def calculate(conn)
    conn
      .add(:planet_weight, conn.fetch(:weight) * conn.fetch(:factor))
  end

  def render(conn)
    conn
      .set_response_body <<-HTML
        <p>You told us your weight on Earth is #{conn.fetch(:weight)}.</p>
        <p>Your weight on #{conn.fetch(:planet).capitalize} is, therefore, #{conn.fetch(:planet_weight).to_i}
    HTML
  end
end

run App.new
