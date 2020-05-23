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
              when: '2020-02-25T22:10:35.008+09:00'
            }
          }
        }
      },
      _links: {
        webui: '/pages/viewpage.action?pageId=123456789'
      }
    }
    original = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)

    actual = Roko::Source::Confluence::EventAdapter.to_report_event(original)

    expect(actual.source).to eq 'Confluence'
    expect(actual.created_at).to eq Time.parse('2020-02-25T22:10:35.008+09:00')
    expect(actual.main.type).to eq 'confluence'
    expect(actual.main.title).to eq 'title'
    expect(actual.main.url).to eq "#{ENV['CONFLUENCE_URL']}/pages/viewpage.action?pageId=123456789"
    expect(actual.sub.type).to eq 'edit'
    expect(actual.sub.title).to eq ''
    expect(actual.sub.url).to eq ''
  end
end
