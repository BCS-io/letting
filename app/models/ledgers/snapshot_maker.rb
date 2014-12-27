###################
#
# SnapshotMaker
#
# Takes a snapshot of the state of an account on transaction.
# The balance and the debits created for that instance.
#
# Used by Account class to wrap (see: debit_maker.gliffy)
#
class SnapshotMaker
  attr_reader :snapshot
  def initialize(account:, debit_period:)
    @snapshot = Snapshot.new account: account, period: debit_period
  end

  def debits?
    mold
    snapshot.debits?
  end

  def invoice(*)
    mold
    snapshot
  end

  private

  def mold
    snapshot
      .debited debits: snapshot.account.exclusive(query_debits: make_debits)
    self
  end

  def make_debits
    snapshot.account.debits_coming(snapshot.period)
  end
end
