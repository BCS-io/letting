module DB
  class Error < StandardError; end
  class AccountRowTypeUnknown < Error; end
  class BalanceNotMatching < Error; end
  class ChargeUnknown < Error; end
  class ChargeCodeUnknown < Error; end
  class ChargeTypeUnknown < Error; end
  class ChargeStuctureUnknown < Error; end
  class CycleUnknown < Error; end
  class ChargedInCodeUnknown < Error; end
  class ClientRefUnknown < Error; end
  class CreditNegativeError < Error; end
  class NotIdempotent < Error; end
  class PeriodUnknown < Error; end
  class PropertyRefUnknown < Error; end
  class MonthUnknown < Error; end
end
