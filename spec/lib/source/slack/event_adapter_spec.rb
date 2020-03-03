# frozen_string_literal: true

require 'spec_helper'
require 'roko/source/slack/event_adapter'
require 'ostruct'
require 'json'

RSpec.describe 'Source::GoogleCalendar::EventAdapter' do
  it 'should convert slack events' do
    original_event_hash = {
      channel: {
        name: 'channel_name'
      },
      ts: '1583151820.000400',
      permalink: 'https://perma.link',
      text: 'sample text'
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)

    actual_events = Roko::Source::Slack::EventAdapter.from([original_event])
    actual_event = actual_events[0]

    expect(actual_event.source).to eq 'slack'
    expect(actual_event.event_type).to eq 'comment'
    expect(actual_event.created_at).to eq Time.parse('2020-03-02T21:23:40+0900')
    expect(actual_event.url).to eq 'https://perma.link'
    expect(actual_event.summary).to eq 'in #channel_name "sample text"'
    expect(actual_event.detail).to eq 'sample text'
  end

  it 'should ellipsize summary when text is long' do
    original_event_hash = {
      channel: {
        name: 'channel_name'
      },
      ts: '1583151820.000400',
      permalink: 'https://perma.link',
      text: 'This is so long text so this should be ellipsize'
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)

    actual_events = Roko::Source::Slack::EventAdapter.from([original_event])
    actual_event = actual_events[0]

    expect(actual_event.summary).to eq 'in #channel_name "This is so long text..."'
    expect(actual_event.detail).to eq 'This is so long text so this should be ellipsize'
  end
end
