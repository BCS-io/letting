class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true
  validates :county, :town, :road, :road_no, presence: true

  def empty?
    attributes.except(*ignored_attrs).values.all?( &:blank? )
  end

  def ignored_attrs
    ['id', 'addressable_id', 'addressable_type', 'created_at', 'updated_at']
  end
end
