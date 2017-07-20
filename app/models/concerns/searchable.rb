module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    def search(search, attributes: nil)
      attributes = self.new.attributes.keys - ["id", "created_at", "updated_at"] if attributes.nil?
      like_sql = attributes.map { |attr| "#{attr} LIKE ?" }.join("OR ")

      where(like_sql, *(["%#{search}%"]*attributes.size))
    end
  end

end
