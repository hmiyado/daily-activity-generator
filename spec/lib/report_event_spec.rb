# frozen_string_literal: true

require 'spec_helper'
require 'time'
require 'roko/report_event'

RSpec.describe 'ReportEvent' do
  it 'should return oneline log' do
    event = Roko::ReportEvent.new(
      'source',
      'eventtype',
      Time.parse('2000-01-01T01:02:56+09:00'),
      'https://url.com',
      'summary',
      'detail'
    )

    allow(event).to receive(:oneline_template).and_return(Roko::DEFAULT_ONELINE_TEMPLATE)

    oneline = event.oneline

    expect(oneline).to eq '2000/01/01 01:02 eventtype [summary](https://url.com)'
  end

  it 'should ignore line separators when oneline log' do
    event = Roko::ReportEvent.new(
      'source',
      'eventtype',
      Time.parse('2000-01-01T12:34:56+09:00'),
      'https://url.com',
      "summary\nwith\nlineseparators",
      'detail\nwith\nlineseparators'
    )

    allow(event).to receive(:oneline_template).and_return(Roko::DEFAULT_ONELINE_TEMPLATE)

    oneline = event.oneline

    expect(oneline).to eq '2000/01/01 12:34 eventtype [summary with lineseparators](https://url.com)'
  end

  it 'should change log template as defined in environment variable' do
    event = Roko::ReportEvent.new(
      'source',
      'eventtype',
      Time.parse('2000-01-01T12:34:56+09:00'),
      'https://url.com',
      "summary\nwith\nlineseparators",
      'detail\nwith\nlineseparators'
    )

    ClimateControl.modify ROKO_ONELINE_TEMPLATE: 'env template' do
      oneline = event.oneline

      expect(oneline).to eq 'env template'
    end
  end
end
