module Charges
  extend ActiveSupport::Concern
  included do
    has_many :charges, dependent: :destroy do

      def chargeables_between date_range
        self.select{|charge| charge.due_between? date_range }.map{|charge| charge.chargeable_info date_range }
      end

      def prepare
        (self.size...MAX_CHARGES).each { charge = self.build }
        self.each {|charge| charge.prepare }
      end

      def clean_up_form
        self.each {|charge| charge.clean_up_form }
        destruction_if :empty?
      end

    private
      def destruction_if matcher
        self.select(&matcher).each {|charge| mark_charge_for_destruction charge }
      end

      def mark_charge_for_destruction charge
        charge.mark_for_destruction
      end
    end
  end
  MAX_CHARGES = 4
end