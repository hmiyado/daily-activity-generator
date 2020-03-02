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
          html_url: 'https://github.com/org/repo/pulls/comment/1',
          body: 'sample body'
        }
      }
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)

    actual_events = DailyReportGenerator::Github::EventAdapter.from([original_event])
    actual_event = actual_events[0]

    expect(actual_event.source).to eq 'github'
    expect(actual_event.event_type).to eq 'PullRequestReviewCommentEvent'
    expect(actual_event.created_at).to eq Time.parse('2020-02-21T09:45:11Z')
    expect(actual_event.url).to eq 'https://github.com/org/repo/pulls/comment/1'
    expect(actual_event.summary).to eq 'PR Comment'
    expect(actual_event.detail).to eq 'sample body'
  end

  it 'should convert created_at of Time instance' do
    original_event_hash = {
      type: 'PullRequestEvent',
      created_at: '2020-02-21T09:45:11Z',
      payload: {
        action: 'open',
        pull_request: {
          html_url: 'https://github.com/org/repo/pulls/1',
          title: 'sample pull request title',
          body: 'sample pull request body'
        }
      }
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)
    original_event.created_at = Time.parse(original_event.created_at)

    actual_events = DailyReportGenerator::Github::EventAdapter.from([original_event])
    actual_event = actual_events[0]

    expect(actual_event.source).to eq 'github'
    expect(actual_event.event_type).to eq 'PullRequestEvent'
    expect(actual_event.created_at).to eq Time.parse('2020-02-21T09:45:11Z')
    expect(actual_event.url).to eq 'https://github.com/org/repo/pulls/1'
    expect(actual_event.summary).to eq 'open sample pull request title'
    expect(actual_event.detail).to eq 'sample pull request body'
  end

  it 'should convert PullRequestEvent open' do
    original_event_hash = {
      type: 'PullRequestEvent',
      created_at: '2020-02-21T09:45:11Z',
      payload: {
        action: 'open',
        pull_request: {
          html_url: 'https://github.com/org/repo/pulls/1',
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
    expect(actual_event.created_at).to eq Time.parse('2020-02-21T09:45:11Z')
    expect(actual_event.url).to eq 'https://github.com/org/repo/pulls/1'
    expect(actual_event.summary).to eq 'open sample pull request title'
    expect(actual_event.detail).to eq 'sample pull request body'
  end

  it 'should convert PullRequestEvent closed' do
    original_event_hash = {
      type: 'PullRequestEvent',
      created_at: '2020-02-21T09:45:11Z',
      payload: {
        action: 'closed',
        pull_request: {
          html_url: 'https://github.com/org/repo/pulls/1',
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
    expect(actual_event.created_at).to eq Time.parse('2020-02-21T09:45:11Z')
    expect(actual_event.url).to eq 'https://github.com/org/repo/pulls/1'
    expect(actual_event.summary).to eq 'closed sample pull request title'
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
    expect(actual_event.created_at).to eq Time.parse('2020-02-21T09:45:11Z')
    expect(actual_event.url).to eq ''
    expect(actual_event.summary).to eq 'create branch feature/new_feature'
    expect(actual_event.detail).to eq ''
  end

  it 'should convert DeleteEvent' do
    original_event_hash = {
      type: 'DeleteEvent',
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
    expect(actual_event.event_type).to eq 'DeleteEvent'
    expect(actual_event.created_at).to eq Time.parse('2020-02-21T09:45:11Z')
    expect(actual_event.url).to eq ''
    expect(actual_event.summary).to eq 'delete branch feature/new_feature'
    expect(actual_event.detail).to eq ''
  end

  it 'should not convert PushEvent' do
    original_event_hash = {
      type: 'PushEvent',
      created_at: '2020-02-21T09:45:11Z',
      payload: {
      }
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)

    actual_events = DailyReportGenerator::Github::EventAdapter.from([original_event])

    expect(actual_events).to be_empty
  end

  it 'should not convert unknown event' do
    original_event_hash = {
      type: 'UnknownEvent',
      created_at: '2020-02-21T09:45:11Z',
      payload: {
      }
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)

    actual_events = DailyReportGenerator::Github::EventAdapter.from([original_event])

    expect(actual_events).to be_empty
  end
end
