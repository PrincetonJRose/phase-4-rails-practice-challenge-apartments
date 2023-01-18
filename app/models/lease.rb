class Lease < ApplicationRecord
  belongs_to :tenant
  belongs_to :apartment

  validates :rent, presence: true, numericality: { greater_than: 0 }

  validate :tenant_can_only_lease_apartment_once

  def tenant_can_only_lease_apartment_once
    if Lease.find_by( tenant: self.tenant, apartment: self.apartment )
      errors.add( :tenant, "can't lease the same apartment twice." )
    end
  end
end
