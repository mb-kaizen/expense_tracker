class API < Sinatra::Base 
    def initialize(ledger:)
        @ledger = ledger
        super() # Rest of initialization from Sinatra
    end
    
end

app = API.new(ledger: Ledger.new)

result = @ledger.record({ 'some' => 'data' })
result.success? # => a Boolean
result.expense_id # => a number
result.error_message # => a string or nil
