# frozen_string_literal: true

require 'spec_helper'
require 'roko/source/github/event_adapter'
require 'ostruct'
require 'json'

RSpec.describe 'Source::Github::EventAdapter' do
  it 'should convert PullRequestReviewCommentEvent' do
    original_event_hash = {
      type: 'PullRequestReviewCommentEvent',
      created_at: '2020-02-21T09:45:11Z',
      payload: {
        comment: {
          html_url: 'https://github.com/org/repo/pulls/comment/1',
          body: 'sample body'
        },
        pull_request: {
          html_url: 'https://github.com/org/repo/pulls/1',
          title: 'sample pull request title',
          body: 'sample pull request body'
        }
      }
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)

    actual = Roko::Source::Github::EventAdapter.to_report_event(original_event)

    expect(actual.source).to eq 'Github'
    expect(actual.created_at).to eq Time.parse('2020-02-21T09:45:11Z')
    expect(actual.main.type).to eq 'PR'
    expect(actual.main.title).to eq 'sample pull request title'
    expect(actual.main.url).to eq 'https://github.com/org/repo/pulls/1'
    expect(actual.sub.type).to eq 'review'
    expect(actual.sub.title).to eq 'sample body'
    expect(actual.sub.url).to eq 'https://github.com/org/repo/pulls/comment/1'
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

    actual = Roko::Source::Github::EventAdapter.to_report_event(original_event)

    expect(actual.source).to eq 'Github'
    expect(actual.created_at).to eq Time.parse('2020-02-21T09:45:11Z')
    expect(actual.main.type).to eq 'PR'
    expect(actual.main.url).to eq 'https://github.com/org/repo/pulls/1'
    expect(actual.main.title).to eq 'sample pull request title'
    expect(actual.sub.type).to eq 'open'
    expect(actual.sub.url).to eq ''
    expect(actual.sub.title).to eq ''
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

    actual = Roko::Source::Github::EventAdapter.to_report_event(original_event)

    expect(actual.source).to eq 'Github'
    expect(actual.created_at).to eq Time.parse('2020-02-21T09:45:11Z')
    expect(actual.main.type).to eq 'PR'
    expect(actual.main.url).to eq 'https://github.com/org/repo/pulls/1'
    expect(actual.main.title).to eq 'sample pull request title'
    expect(actual.sub.type).to eq 'open'
    expect(actual.sub.url).to eq ''
    expect(actual.sub.title).to eq ''
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

    actual = Roko::Source::Github::EventAdapter.to_report_event(original_event)

    expect(actual.source).to eq 'Github'
    expect(actual.created_at).to eq Time.parse('2020-02-21T09:45:11Z')
    expect(actual.main.type).to eq 'PR'
    expect(actual.main.url).to eq 'https://github.com/org/repo/pulls/1'
    expect(actual.main.title).to eq 'sample pull request title'
    expect(actual.sub.type).to eq 'closed'
    expect(actual.sub.url).to eq ''
    expect(actual.sub.title).to eq ''
  end

  it 'should not convert CreateEvent' do
    original_event_hash = {
      type: 'CreateEvent',
      created_at: '2020-02-21T09:45:11Z',
      payload: {
        ref_type: 'branch',
        ref: 'feature/new_feature'
      }
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)

    actual = Roko::Source::Github::EventAdapter.to_report_event(original_event)

    expect(actual).to be_nil
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

    actual = Roko::Source::Github::EventAdapter.to_report_event(original_event)

    expect(actual).to be_nil
  end

  it 'should not convert PushEvent' do
    original_event_hash = {
      type: 'PushEvent',
      created_at: '2020-02-21T09:45:11Z',
      payload: {
      }
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)

    actual = Roko::Source::Github::EventAdapter.to_report_event(original_event)

    expect(actual).to be_nil
  end

  it 'should not convert unknown event' do
    original_event_hash = {
      type: 'UnknownEvent',
      created_at: '2020-02-21T09:45:11Z',
      payload: {
      }
    }
    original_event = JSON.parse(original_event_hash.to_json, object_class: OpenStruct)

    actual = Roko::Source::Github::EventAdapter.to_report_event(original_event)

    expect(actual).to be_nil
  end
end
