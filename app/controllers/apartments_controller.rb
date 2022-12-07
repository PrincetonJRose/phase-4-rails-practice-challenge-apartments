class ApartmentsController < ApplicationController

    def index
        apartments = Apartment.all
        render json: apartments, except: [:created_at, :updated_at], status: :ok
    end

    def show
        apartment = Apartment.find_by( id: params[:id] )
        if apartment
            render json: apartment, except: [:created_at, :updated_at], status: :ok
        else
            apartment_not_found
        end
    end

    def create
        apartment = Apartment.new( apartment_params )
        if apartment.valid?
            apartment.save
            render json: apartment, status: :created
        else
            cannot_process_apartment( apartment )
        end
    end

    def update
        apartment = Apartment.find_by( id: params[:id] )
        if apartment
            apartment.number = apartment_params[:number]
            if apartment.valid?
                apartment.save
                render json: apartment, status: :ok
            else
                cannot_process_apartment( apartment )
            end
        else
            apartment_not_found
        end
    end

    def destroy
        apartment = Apartment.find_by( id: params[:id] )
        if apartment
            apartment.leases.destroy_all
            apartment.destroy
            # render json: apartment, status: :no_content
            head :no_content
        else
            apartment_not_found
        end
    end

    private

    def apartment_params
        params.require( :apartment ).permit( :number )
    end

    def apartment_not_found
        render json: { errors: ['Apartment not found.'] }, status: :not_found
    end

    def cannot_process_apartment apartment
        render json: { errors: apartment.errors.full_messages }, status: :unprocessable_entity
    end
end
