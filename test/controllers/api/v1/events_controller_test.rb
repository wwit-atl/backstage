require "test_helper"

class Api::V1::EventsControllerTest < ActionController::TestCase

  def setup
    @request.accept = 'application/vnd.backstage.v1'
    @api_key        = ApiKey.create
    @show           = FactoryGirl.create(:show)
  end

  test 'returns 401 without access_token' do
    get :events, date: @show.date, format: :json

    assert_response :unauthorized
  end

  test 'returns an array of events when given a date' do
    json = [{ id:       @show.id,
              name:     @show.name,
              date:     @show.date.to_s,
              showTime: @show.to_datetime }]

    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@api_key.access_token)

    get :events, :format => :json, :date => @show.date

    assert_response :success
    assert_equal json, JSON.parse(@response.body, symbolize_names: true)
  end
end
