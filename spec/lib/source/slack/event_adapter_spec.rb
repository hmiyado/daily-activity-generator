# frozen_string_literal: true

require 'spec_helper'
require 'roko/source/slack/event_adapter'
require 'ostruct'
require 'json'

RSpec.describe 'Source::Slack::EventAdapter' do
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

    actual = Roko::Source::Slack::EventAdapter.to_report_event(original_event)

    expect(actual.source).to eq 'Slack'
    expect(actual.created_at).to eq Time.parse('2020-03-02T21:23:40+0900')
    expect(actual.main.type).to eq 'channel'
    expect(actual.main.url).to eq ''
    expect(actual.main.title).to eq '#channel_name'
    expect(actual.sub.type).to eq 'post'
    expect(actual.sub.url).to eq 'https://perma.link'
    expect(actual.sub.title).to eq 'sample text'
  end
end
