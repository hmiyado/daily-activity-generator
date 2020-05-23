module Roko
  module Report
    class Entry
      attr_reader :type, :title, :url

      # @param type [String]
      # @param title [String]
      # @param url [String]
      def initialize(type, title, url)
        @type = type
        @title = title
        @url = url
      end
    end
  end
end