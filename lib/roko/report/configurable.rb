# frozen_string_literal: true

module Roko
  module Report
    module Configurable
      DEFAULT_ONELINE_TEMPLATE = '%{main_type} [%{main_title}](%{main_url}) %{Y}/%{m}/%{d} %{H}:%{M} %{sub_type} [%{sub_title}](%{sub_url})'

      def format_template
        env_template = ENV.fetch('ROKO_ONELINE_TEMPLATE', '')
        return env_template unless env_template.nil? || env_template.empty?

        DEFAULT_ONELINE_TEMPLATE
      end
    end
  end
end
