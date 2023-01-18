class TenantApartmentsSerializer < ActiveModel::Serializer
  attributes :id, :name, :age

  has_many :apartments
end
