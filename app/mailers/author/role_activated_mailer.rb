# frozen_string_literal: true

module Author
  # Sends notification about approved author account
  class RoleActivatedMailer < ApplicationMailer
    def notify(author_id)
      @author = Roles::Author.find(author_id)
      mail(to: @author.user.email, subject: t('idea.wizard.mailers.activated.subject'))
    end
  end
end
