class TenantsController < ApplicationController

    rescue_from ActiveRecord::RecordNotFound, with: :tenant_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :tenant_invalid

    def index
        render json: Tenant.all, status: :ok
    end

    def show
        tenant = Tenant.find( params[:id] )
        render json: tenant, serializer: TenantApartmentsSerializer, status: :ok
    end

    def create
        tenant = Tenant.create!( tenant_params )
        render json: tenant, status: :created
    end

    def update
        tenant = Tenant.find( params[:id] )
        tenant.update!( tenant_params )
        render json: tenant, status: :ok
    end

    def destroy
        tenant = Tenant.find( params[:id] )
        tenant.destroy
        head :no_content
    end

    private

    def tenant_params
        params.require( :tenant ).permit( :name, :age )
    end

    def tenant_not_found
        render json: { errors: ['Tenant was not found.'] }, status: :not_found
    end

    def tenant_invalid invalid_tenant
        render json: { errors: invalid_tenant.record.errors.full_messages }, status: 422
    end


end
