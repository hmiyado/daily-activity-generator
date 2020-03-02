# frozen_string_literal: true

require 'spec_helper'
require 'daily_report_generator/source/google_calendar/event_adapter'
require 'ostruct'
require 'json'

RSpec.describe 'Source::GoogleCalendar::EventAdapter' do
  it 'should convert google calendar events' do
    original_event_hash = {
      start: {
        date: '2020-01-01',
        date_time: '2020-01-01T12:34+0900'
      },
      html_link: 'https://html.link',
      summary: 'event summary',
      description: 'description'
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)
    original_event.start.date_time = DateTime.parse(original_event.start.date_time)

    actual_events = DailyReportGenerator::Source::GoogleCalendar::EventAdapter.from([original_event])
    actual_event = actual_events[0]

    expect(actual_event.source).to eq 'google calendar'
    expect(actual_event.event_type).to eq 'MTG'
    expect(actual_event.created_at).to eq Time.parse('2020-01-01T12:34:00+09:00')
    expect(actual_event.url).to eq 'https://html.link'
    expect(actual_event.summary).to eq 'event summary'
    expect(actual_event.detail).to eq 'description'
  end

  it 'should convert google calendar all-day event' do
    original_event_hash = {
      start: {
        date: '2020-01-01'
      },
      html_link: 'https://html.link',
      summary: 'event summary',
      description: 'description'
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)
    original_event.start.date = Date.parse(original_event.start.date)

    actual_events = DailyReportGenerator::Source::GoogleCalendar::EventAdapter.from([original_event])
    actual_event = actual_events[0]

    expect(actual_event.source).to eq 'google calendar'
    expect(actual_event.event_type).to eq 'MTG'
    expect(actual_event.created_at).to eq Time.parse('2020-01-01T00:00:00+09:00')
    expect(actual_event.url).to eq 'https://html.link'
    expect(actual_event.summary).to eq 'event summary'
    expect(actual_event.detail).to eq 'description'
  end

  it 'should not convert google calendar event without start time' do
    original_event_hash = {
      html_link: 'https://html.link',
      summary: 'event summary',
      description: 'description'
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)

    actual_events = DailyReportGenerator::Source::GoogleCalendar::EventAdapter.from([original_event])

    expect(actual_events).to be_empty
  end
end
