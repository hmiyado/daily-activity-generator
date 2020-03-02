# frozen_string_literal: true

require 'spec_helper'
require 'time'
require 'daily_report_generator/report_event'

RSpec.describe 'ReportEvent' do
  it 'should return oneline log' do
    event = DailyReportGenerator::ReportEvent.new(
      'https://source.com',
      'eventtype',
      Time.parse('2000-01-01T12:34:56+09:00'),
      'https://url.com',
      'summary',
      'detail'
    )
    
    oneline = event.oneline

    expect(oneline).to eq '2000/01/01 12:34 eventtype [summary](https://url.com)' 
  end
end
