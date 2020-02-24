require 'spec_helper'
require 'daily_report_generator/github/event_adapter'

RSpec.describe 'Github::EventAdapter' do
    it 'should convert PullRequestReviewCommentEvent' do 
        original_event = double('PullRequestReviewCommentEvent')
        payload = double('payload')
        comment = double('comment')
        allow(original_event).to receive(:type).and_return('PullRequestReviewCommentEvent')
        allow(original_event).to receive(:created_at).and_return('2020-02-21T09:45:11Z')
        allow(original_event).to receive(:payload).and_return(payload)
        allow(payload).to receive(:comment).and_return(comment)
        allow(comment).to receive(:url).and_return('https://github.com/org/repo/pulls/comment/1')
        allow(comment).to receive(:body).and_return('sample body')

        actual_events = DailyReportGenerator::Github::EventAdapter.from([original_event])
        actual_event = actual_events[0]

        expect(actual_event.source).to eq 'github'
        expect(actual_event.event_type).to eq 'PullRequestReviewCommentEvent'
        expect(actual_event.created_at).to eq '2020-02-21T09:45:11Z'
        expect(actual_event.url).to eq 'https://github.com/org/repo/pulls/comment/1'
        expect(actual_event.summary).to eq 'PR Comment'
        expect(actual_event.detail).to eq 'sample body'

    end
end