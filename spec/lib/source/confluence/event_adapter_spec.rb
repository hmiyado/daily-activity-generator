# frozen_string_literal: true

require 'spec_helper'
require 'roko/source/confluence/event_adapter'
require 'json'

RSpec.describe 'Source::Confluence::EventAdapter' do
  it 'should convert' do
    original_event_hash = {
      title: 'title',
      metadata: {
        currentuser: {
          lastmodified: {
            version: {
              "when" => '2020-02-25T22:10:35.008+09:00'
            }
          }
        }
      },
      _links: {
        webui: '/pages/viewpage.action?pageId=123456789'
      }
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)

    actual_events = Roko::Source::Confluence::EventAdapter.from([original_event])
    actual_event = actual_events[0]

    expect(actual_event.source).to eq 'confluence'
    expect(actual_event.event_type).to eq 'document'
    expect(actual_event.created_at).to eq Time.parse('2020-02-25T22:10:35.008+09:00')
    expect(actual_event.url).to eq "https://#{ENV['CONFLUENCE_HOST']}#{ENV['CONFLUENCE_API_PATH']}/pages/viewpage.action?pageId=123456789"
    expect(actual_event.summary).to eq 'title'
    expect(actual_event.detail).to eq ''
  end
end
