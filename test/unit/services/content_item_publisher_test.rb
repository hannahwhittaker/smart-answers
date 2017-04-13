require 'test_helper'

class ContentItemPublisherTest < ActiveSupport::TestCase
  setup do
    load_path = fixture_file('smart_answer_flows')
    SmartAnswer::FlowRegistry.stubs(:instance).returns(stub("Flow registry", find: @flow, load_path: load_path))
  end

  test 'sending item to content store' do
    draft_request = stub_request(:put, "https://publishing-api.test.gov.uk/v2/content/3e6f33b8-0723-4dd5-94a2-cab06f23a685")
    publishing_request = stub_request(:post, "https://publishing-api.test.gov.uk/v2/content/3e6f33b8-0723-4dd5-94a2-cab06f23a685/publish")

    presenter = FlowRegistrationPresenter.new(stub('flow', name: 'bridge-of-death', content_id: '3e6f33b8-0723-4dd5-94a2-cab06f23a685', external_related_links: nil))

    ContentItemPublisher.new.publish([presenter])

    assert_requested draft_request
    assert_requested publishing_request
  end

  context "#unpublish" do
    should 'send unpublish request to content store' do
      unpublish_url = 'https://publishing-api.test.gov.uk/v2/content/content-id/unpublish'
      unpublish_request = stub_request(:post, unpublish_url)

      ContentItemPublisher.new.unpublish('content-id')

      assert_requested unpublish_request
    end

    should 'raises exception if smart answer does not exist' do
      exception = assert_raises(RuntimeError) do
        ContentItemPublisher.new.unpublish(nil)
      end

      assert_equal "Content id has not been supplied", exception.message
    end
  end

  context "#redirect_smart_answer" do
    setup do
      SecureRandom.stubs(:uuid).returns('content-id')
      create_url = 'https://publishing-api.test.gov.uk/v2/content/content-id'
      @create_request = stub_request(:put, create_url)
      publish_url = 'https://publishing-api.test.gov.uk/v2/content/content-id/publish'
      @publish_request = stub_request(:post, publish_url)
      router_url = 'https://router-api.test.gov.uk/routes'
      @router_request = stub_request(:put, router_url)
    end

    should 'send a redirect and publish request to content store' do
      ContentItemPublisher.new.redirect_smart_answer('/path', '/destination-path')

      assert_requested @create_request
      assert_requested @publish_request
      assert_requested @router_request
    end

    should 'raise exception and not attempt publishing and router requests, when create request fails' do
      GdsApi::Response.any_instance.stubs(:code).returns(500)
      exception = assert_raises(RuntimeError) do
        ContentItemPublisher.new.redirect_smart_answer('/path', '/destination-path')
      end

      assert_equal "This content item has not been created", exception.message
      assert_requested @create_request
      assert_not_requested @publish_request
      assert_not_requested @router_request
    end

    should 'raises exception if destination is not defined' do
      exception = assert_raises(RuntimeError) do
        ContentItemPublisher.new.redirect_smart_answer('/path', nil)
      end

      assert_equal "The destination or path isn't defined", exception.message
    end

    should 'raises exception if path is not defined' do
      exception = assert_raises(RuntimeError) do
        ContentItemPublisher.new.redirect_smart_answer(nil, '/destination-path')
      end

      assert_equal "The destination or path isn't defined", exception.message
    end
  end
end
