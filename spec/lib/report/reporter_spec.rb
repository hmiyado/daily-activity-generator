# frozen_string_literal: true

require 'spec_helper'
require 'time'
require 'roko/report/reporter'
require 'roko/report/event'
require 'roko/report/entry'

RSpec.describe 'Report::Reporter' do
  it 'should format event' do
    event = Roko::Report::Event.new(
      'source',
      Time.parse('2000-01-01T01:02:56+09:00'),
      Roko::Report::Entry.new(
        'main.type',
        'main.title',
        'https://main.url'
      ),
      Roko::Report::Entry.new(
        'sub.type',
        'sub.title',
        'https://sub.url'
      )
    )
    reporter = Roko::Report::Reporter.new

    event_template = '%{source} %{Y}/%{m}/%{d} %{H}:%{M}'
    allow(reporter).to receive(:format_template).and_return(event_template)
    expect(reporter.format(event)).to eq('source 2000/01/01 01:02')

    event_template = '%{main_type} %{main_title} %{main_url}'
    allow(reporter).to receive(:format_template).and_return(event_template)
    expect(reporter.format(event)).to eq('main.type main.title https://main.url')

    event_template = '%{sub_type} %{sub_title} %{sub_url}'
    allow(reporter).to receive(:format_template).and_return(event_template)
    expect(reporter.format(event)).to eq('sub.type sub.title https://sub.url')
  end
end
