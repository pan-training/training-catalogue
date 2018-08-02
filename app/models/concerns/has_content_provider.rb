module HasContentProvider

  extend ActiveSupport::Concern

  included do
    belongs_to :content_provider, optional: true
    before_save :check_content_provider_precedence
  end

  private

  def check_content_provider_precedence
    if will_save_change_to_content_provider_id?
      previous_content_provider_id = content_provider_id_before_last_save
      previous_content_provider = ContentProvider.where(id: previous_content_provider_id).first

      # Revert back to the old content provider if it had a higher precedence
      if previous_content_provider && content_provider &&
          previous_content_provider.precedence > content_provider.precedence
        self.content_provider = previous_content_provider
      end
    end
  end

end
