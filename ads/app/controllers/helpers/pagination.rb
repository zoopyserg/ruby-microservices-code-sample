# frozen_string_literal: true

module Pagination
  protected

  def pagination_links(scope)
    return {} if scope.total_pages.zero?

    links = {
      first: pagination_link(page: 1),
      last: pagination_link(page: scope.total_pages)
    }

    links[:next] = pagination_link(page: scope.next_page) if scope.next_page.present?
    links[:prev] = pagination_link(page: scope.prev_page) if scope.prev_page.present?

    links
  end

  private

  def pagination_link(page:)
    "/api/v1/ads?page=#{page}"
  end
end
