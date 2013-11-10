class Debtors
  attr_reader :account
  attr_reader :human_ref_range
  attr_accessor :count

  def self.go human_ref_range
    new(human_ref_range).calculate
  end

  def initialize human_ref_range
    @human_ref_range = human_ref_range
    @count = 0
  end

  def calculate
    Account.all.each do |account|
      @account = account
      balance_status unless filtered
    end
  end

  def balance_status
     if debit_amount != credit_amount
       @count += 1
       puts no_balance_msg
     end
  end

  def filtered
    if human_ref_range.nil?
      false
    else
      filtered_condition
    end
  end

  def filtered_condition
    human_ref_range.exclude? account.property.human_ref
  end

  def debit_amount
    account.debits.where(on_date: date_range).to_a.sum(&:amount)
  end

  def credit_amount
    account.credits.where(on_date: date_range).to_a.sum(&:amount)
  end

  def date_range
    before_first_db_date..(last_account_credit || Date.current.end_of_year)
  end

  def last_account_credit
    account.credits.order('on_date desc').try(:first).try(:on_date)
  end

  def before_first_db_date
    Date.new(2000, 1, 1)
  end

  def no_balance_msg
    "#{@count} Property #{account.property.human_ref} Balance: #{debit_amount - credit_amount}"
  end

end