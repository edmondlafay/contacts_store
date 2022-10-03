require 'test_helper'

class ContaxtTest < ActionDispatch::IntegrationTest
  #index
  test 'index returns an empty list when no contact exists' do
    get '/api/contacts'
    assert_response :success
    assert_equal({ contacts: [] }.to_json, response.body, 'Empty response is not as expected')
  end

  test 'index returns contact list when contact exists' do
    event = Event.create(name: "test#{Time.now.to_f} event")
    contact = Contact.create(
      email: "test#{Time.now.to_f}@domaine.fr",
      first_name: 'first_name',
      last_name: 'last_name',
      company: 'company',
      events: [event]
    )
    get '/api/contacts'
    assert_response :success
    assert_equal(
      { contacts: [{
        email: contact.email,
        first_name: 'first_name',
        last_name: 'last_name',
        company: 'company',
        website: nil,
        events: [event.name],
        created_at: Date.today,
        updated_at: Date.today
      }] }.to_json,
      response.body,
      'Populated response is not as expected'
    )
  end

  #create
  test 'create returns contact list when creation successful' do
    post '/api/contacts', params: {
      email: "creation@test.com",
      first_name: 'first_name',
      last_name: 'last_name',
      company: 'company'
    }
    assert_response :success
    assert_equal({ data: {attributes: {
      email: "creation@test.com",
      first_name: 'first_name',
      last_name: 'last_name',
      company: 'company',
      website: nil,
      events: [],
      created_at: Date.today,
      updated_at: Date.today
    }} }.to_json, response.body, 'Create response is not as expected')
  end

  test 'create returns errors when params missing' do
    post '/api/contacts', params: {}
    assert_response :bad_request
    assert_equal({ 
      email: ['is missing'],
      first_name: ['is missing'],
      last_name: ['is missing'],
      company: ['is missing']
     }.to_json, response.body, 'Create response is not as expected')
  end

  test 'create returns errors when bad params given' do
    post '/api/contacts', params: {
      email: 'zeijb',
      first_name: 'first_name',
      last_name: 'last_name',
      company: 'company'
    }
    assert_response :bad_request
    assert_equal({
      email: ['is in invalid format']
     }.to_json, response.body, 'Create response is not as expected')
  end

  test 'create returns errors when existing email params given' do
    contact = Contact.create(
      email: "test#{Time.now.to_f}@domaine.fr",
      first_name: 'first_name',
      last_name: 'last_name',
      company: 'company',
    )
    post '/api/contacts', params: {
      email: contact.email,
      first_name: 'first_name',
      last_name: 'last_name',
      company: 'company'
    }
    assert_response :bad_request
    assert_equal(' ', response.body, 'Create response is not as expected')
  end

  #delete
  test 'delete returns :ok when contact exists' do
    contact = Contact.create(
      email: "test#{Time.now.to_f}@domaine.fr",
      first_name: 'first_name',
      last_name: 'last_name',
      company: 'company'
    )
    delete '/api/contacts', params: {
      email: contact.email
    }
    assert_response :success
  end

  test 'delete returns :ok when no contact exists' do
    delete '/api/contacts', params: {
      email: "test#{Time.now.to_f}@domaine.fr"
    }
    assert_response :success
  end

  test 'delete returns errors when bad params given' do
    delete '/api/contacts', params: {
      email: 'zeijb'
    }
    assert_response :bad_request
    assert_equal({
      email: ['is in invalid format']
     }.to_json, response.body, 'Delete response is not as expected')
  end
end
