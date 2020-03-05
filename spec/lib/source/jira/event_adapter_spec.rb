# frozen_string_literal: true

require 'spec_helper'
require 'jira-ruby'
require 'roko/source/jira/event_adapter'
require 'ostruct'
require 'json'

RSpec.describe 'Source::Jira::EventAdapter' do
  it 'should convert a jira event' do
    original_event = JIRA::Resource::Issue
                     .build(nil, {
                              'key' => 'KEY-1234',
                              'fields' => {
                                'updated' => '2019-12-06T18:15:58.000+0900',
                                'summary' => 'summary',
                                'description' => 'description'
                              }
                            })

    actual_event = Roko::Source::Jira::EventAdapter.to_report_event(original_event)

    expect(actual_event.source).to eq 'jira'
    expect(actual_event.event_type).to eq 'ticket'
    expect(actual_event.created_at).to eq Time.parse('2019-12-06T18:15:58.000+0900')
    expect(actual_event.url).to eq "#{ENV['JIRA_URL']}#{ENV['JIRA_CONTEXT_PATH']}/browse/KEY-1234"
    expect(actual_event.summary).to eq '[KEY-1234] summary'
    expect(actual_event.detail).to eq 'description'
  end
end
