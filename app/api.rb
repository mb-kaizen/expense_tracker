require 'sinatra/base'
require 'json'
require_relative 'ledger'

module ExpenseTracker
    class API < Sinatra::Base 
        post '/expenses' do
            # JSON.generate('expense_id' => 42)
            # status 404
            @ledger = Ledger.new

            expense = JSON.parse(request.body.read)
            result = @ledger.record(expense)
            JSON.generate('expense_id' => result.expense_id)
        end

        get '/expenses/:date' do
            JSON.generate([])
        end
    end
end