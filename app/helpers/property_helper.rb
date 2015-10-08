####
#
# PropertyHelper
#
####
#
module PropertyHelper
  def client_list
    Client.includes(:entities).order(:human_ref).map do |client|
      ["#{client.human_ref} #{client.full_names}", client.id]
    end
  end

  def property_prev
    return '' unless @property.prev

    @property.prev.human_ref
  end

  def property_next
    return '' unless @property.next

    @property.next.human_ref
  end
end
