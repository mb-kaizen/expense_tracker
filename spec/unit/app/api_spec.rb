require_relative '../../../app/api'
require 'rack/test'

module ExpenseTracker
    RecordResult = Struct.new(:success?, :expense_id, :error_message)

    RSpec.describe API do
        include Rack::Test::Methods

        def app
            API.new(ledger: ledger)
        end

        let(:ledger) { instance_double('ExpenseTracker::Ledger') }
        
        describe 'POST /expenses' do
            let(:parsed) { JSON.parse(last_response.body) }
            let(:expense) { { 'some' => 'data' } }

            def check_response_includes(key, value)
                expect(parsed).to include(key => value)
            end

            context 'when the expense is successfully recorded' do
                before do
                    allow(ledger).to receive(:record)
                        .with(expense)
                        .and_return(RecordResult.new(true, 417, nil))
                end

                it 'returns the expense id' do
                    post '/expenses', JSON.generate(expense)
                    check_response_includes('expense_id', 417)
                end

                it 'responds with a 200 (OK)' do
                    post '/expenses', JSON.generate(expense)
                    expect(last_response.status).to eq(200)
                end
            end

            context 'when the expense fails validation' do
                before do
                    allow(ledger).to receive(:record)
                        .with(expense)
                        .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
                end
                it 'returns and error message' do
                    post '/expenses', JSON.generate(expense)
                    check_response_includes('error', 'Expense incomplete')
                end
                it 'responds with a 422 (Unprocessable entity)' do
                    post '/expenses', JSON.generate(expense)
                    expect(last_response.status).to eq(422)
                end
            end
        end

        describe 'GET /expenses/:date' do
            context 'when expense exist on the given date' do
                it 'returns the expense records as JSON'
                it 'responds with a 200 (OK)'
            end

            context 'when there are no expenses on the given date' do
                it 'returns an empty array as JSON'
                it 'responds with a 200 (OK)'
            end
        end
    end
end