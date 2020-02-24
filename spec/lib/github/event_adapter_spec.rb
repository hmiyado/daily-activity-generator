# frozen_string_literal: true

require 'spec_helper'
require 'daily_report_generator/github/event_adapter'
require 'ostruct'
require 'json'

RSpec.describe 'Github::EventAdapter' do
  it 'should convert PullRequestReviewCommentEvent' do
    original_event_hash = {
      type: 'PullRequestReviewCommentEvent',
      created_at: '2020-02-21T09:45:11Z',
      payload: {
        comment: {
          url: 'https://github.com/org/repo/pulls/comment/1',
          body: 'sample body'
        }
      }
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)

    actual_events = DailyReportGenerator::Github::EventAdapter.from([original_event])
    actual_event = actual_events[0]

    expect(actual_event.source).to eq 'github'
    expect(actual_event.event_type).to eq 'PullRequestReviewCommentEvent'
    expect(actual_event.created_at).to eq '2020-02-21T09:45:11Z'
    expect(actual_event.url).to eq 'https://github.com/org/repo/pulls/comment/1'
    expect(actual_event.summary).to eq 'PR Comment'
    expect(actual_event.detail).to eq 'sample body'
  end

  it 'should convert PullRequestEvent open' do
    original_event_hash = {
      type: 'PullRequestEvent',
      created_at: '2020-02-21T09:45:11Z',
      payload: {
        action: 'open',
        pull_request: {
          url: 'https://github.com/org/repo/pulls/1',
          title: 'sample pull request title',
          body: 'sample pull request body'
        }
      }
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)

    actual_events = DailyReportGenerator::Github::EventAdapter.from([original_event])
    actual_event = actual_events[0]

    expect(actual_event.source).to eq 'github'
    expect(actual_event.event_type).to eq 'PullRequestEvent'
    expect(actual_event.created_at).to eq '2020-02-21T09:45:11Z'
    expect(actual_event.url).to eq 'https://github.com/org/repo/pulls/1'
    expect(actual_event.summary).to eq 'open sample pull request title'
    expect(actual_event.detail).to eq 'sample pull request body'
  end

  it 'should convert CreateEvent' do
    original_event_hash = {
      type: 'CreateEvent',
      created_at: '2020-02-21T09:45:11Z',
      payload: {
        ref_type: 'branch',
        ref: 'feature/new_feature'
      }
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)

    actual_events = DailyReportGenerator::Github::EventAdapter.from([original_event])
    actual_event = actual_events[0]

    expect(actual_event.source).to eq 'github'
    expect(actual_event.event_type).to eq 'CreateEvent'
    expect(actual_event.created_at).to eq '2020-02-21T09:45:11Z'
    expect(actual_event.url).to eq ''
    expect(actual_event.summary).to eq 'create branch feature/new_feature'
    expect(actual_event.detail).to eq ''
  end
end
