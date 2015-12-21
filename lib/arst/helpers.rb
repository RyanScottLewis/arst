module ARST
  module Helpers
    # Convert a string from
    def self.underscore(string)
      string.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z])/, '\1_\2').tr("-", "_").downcase
    end
  end
end
