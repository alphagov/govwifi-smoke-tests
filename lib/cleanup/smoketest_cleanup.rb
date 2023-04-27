require 'logger'
class SmoketestCleanup
  def self.clean
    logger = Logger.new($stdout)
    logger.info("Starting daily smoke test user and session deletion")
    users_to_delete = User
      .where { contact.like "govwifi-tests+%@digital.cabinet-office.gov.uk" }
      .where { created_at < Time.now - (10 * 60) }
    total = if users_to_delete.count.positive?
      Session.where(username: users_to_delete.select_map(:username)).delete
      users_to_delete.delete
    end

    logger.info("Finished smoke test user deletion, #{total || "no"} rows affected")
  end
end
