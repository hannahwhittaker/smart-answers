require 'statsd'
require 'gds_api/publishing_api_v2'
require 'gds_api/content_store'
require 'gds_api/imminence'
require 'gds_api/worldwide'
require 'gds_api/rummager'
require 'gds_api/router'

module Services
  def self.publishing_api
    @publishing_api ||= GdsApi::PublishingApiV2.new(
      Plek.new.find('publishing-api'),
      bearer_token: ENV['PUBLISHING_API_BEARER_TOKEN'] || 'example'
    )
  end

  def self.imminence_api
    @imminence_api ||= GdsApi::Imminence.new(Plek.new.find('imminence'))
  end

  def self.worldwide_api
    @worldwide_api ||= GdsApi::Worldwide.new(Plek.new.find('whitehall-admin'))
  end

  def self.rummager
    @rummager ||= GdsApi::Rummager.new(Plek.find("rummager"))
  end

  def self.router_api
    @router ||= GdsApi::Router.new(
      Plek.new.find('router-api')
    )
  end

  def self.content_store
    @content_store ||= GdsApi::ContentStore.new(
      Plek.new.find('content-store')
    )
  end

  def self.statsd
    @statsd ||= begin
      statsd_client = Statsd.new("localhost")
      statsd_client.namespace = ENV['GOVUK_STATSD_PREFIX'].to_s
      statsd_client
    end
  end
end
