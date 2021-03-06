# frozen_string_literal: true

module ServiceDiscovery::ControllerMethods
  def self.included(base)
    base.class_eval do
      attr_reader :cluster
      helper_method :service_discovery_accessible?, :service_discovery_usable?, :service_discovery_presenter
    end
  end

  protected

  def service_discovery_presenter
    @service_discovery_presenter ||= ServiceDiscoveryOAuthFlowPresenter.new(current_account, request)
  end

  def service_discovery_usable?
    oauth_manager.service_usable?
  end

  def service_discovery_accessible?
    oauth_manager.service_accessible?
  end

  def find_cluster
    @cluster ||= ::ServiceDiscovery::ClusterClient.new bearer_token: oauth_manager.access_token
  end

  def oauth_manager
    @oauth_manager ||= ServiceDiscovery::OAuthManager.new(current_user)
  end
end
