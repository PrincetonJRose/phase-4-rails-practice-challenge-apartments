class ApartmentsController < ApplicationController

    rescue_from ActiveRecord::RecordNotFound, with: :apartment_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :apartment_not_valid

    def index
        render json: Apartment.all, status: :ok
    end

    def show
        apartment = Apartment.find( params[:id] )
        render json: apartment, serializer: ApartmentResidentsSerializer, status: :ok
    end

    def create
        apartment = Apartment.create!( apartment_params )
        render json: apartment, status: :created
    end

    def update
        apartment = Apartment.find( params[:id] )
        apartment.update!( apartment_params )
        render json: apartment, status: :ok
    end

    def destroy
        apartment = Apartment.find( params[:id] )
        apartment.destroy
        head :no_content
    end

    def new_lease
        apartment = Apartment.find( params[:id] )
        tenant = Tenant.find_by( id: lease_params[:tenant_id] )
        if tenant
            lease = Lease.create!( apartment: apartment, tenant: tenant, rent: lease_params[:rent] )
            render json: lease, status: :created
        else
            render json: { errors: ['Tenant was not found.'] }, status: :not_found
        end
    end

    def end_lease
        apartment = Apartment.find( params[:apartment_id] )
        lease = Lease.find_by( id: params[:lease_id] )
        if lease and lease.apartment == apartment
            lease.destroy
            head :no_content
        else
            render json: { errors: ["Lease was not found."] }, status: :not_found
        end
    end

    private

    def lease_params
        params.permit( :tenant_id, :rent )
    end

    def apartment_not_valid invalid_apartment
        render json: { errors: invalid_apartment.record.errors.full_messages }, status: 422
    end

    def apartment_params
        params.require( :apartment ).permit( :number )
    end

    def apartment_not_found
        render json: { errors: ['Apartment was not found. 🏨']  }, status: :not_found
    end
end
