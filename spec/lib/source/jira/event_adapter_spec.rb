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

    actual = Roko::Source::Jira::EventAdapter.to_report_event(original_event)

    expect(actual.source).to eq 'JIRA'
    expect(actual.created_at).to eq Time.parse('2019-12-06T18:15:58.000+0900')
    expect(actual.main.type).to eq 'task'
    expect(actual.main.title).to eq '[KEY-1234] summary'
    expect(actual.main.url).to eq "#{ENV['JIRA_URL']}#{ENV['JIRA_CONTEXT_PATH']}/browse/KEY-1234"
    expect(actual.sub.type).to eq 'edit'
    expect(actual.sub.title).to eq ''
    expect(actual.sub.url).to eq ''
  end
end
