# frozen_string_literal: true

require 'spec_helper'
require 'roko/source/google_calendar/event_adapter'
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

    actual = Roko::Source::GoogleCalendar::EventAdapter.to_report_event(original_event)

    expect(actual.source).to eq 'Google Calendar'
    expect(actual.created_at).to eq Time.parse('2020-01-01T12:34:00+09:00')
    expect(actual.main.type).to eq 'MTG'
    expect(actual.main.title).to eq 'event summary'
    expect(actual.main.url).to eq 'https://html.link'
    expect(actual.sub.type).to eq 'start'
    expect(actual.sub.title).to eq ''
    expect(actual.sub.url).to eq ''
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

    actual = Roko::Source::GoogleCalendar::EventAdapter.to_report_event(original_event)

    expect(actual.source).to eq 'Google Calendar'
    expect(actual.created_at).to eq Time.parse('2020-01-01T00:00:00+09:00')
    expect(actual.main.type).to eq 'MTG'
    expect(actual.main.title).to eq 'event summary'
    expect(actual.main.url).to eq 'https://html.link'
    expect(actual.sub.type).to eq 'start'
    expect(actual.sub.title).to eq ''
    expect(actual.sub.url).to eq ''
  end

  it 'should not convert google calendar event without start time' do
    original_event_hash = {
      html_link: 'https://html.link',
      summary: 'event summary',
      description: 'description'
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)

    actual_event = Roko::Source::GoogleCalendar::EventAdapter.to_report_event(original_event)
    expect(actual_event).to be_nil
  end
end
