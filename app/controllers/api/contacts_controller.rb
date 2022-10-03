module Api
  class ContactsController < ApplicationController
    def index
      render json: { contacts: Contact.all.preload(:events).map(&:attributes) }
    end

    def create
      validated_params = params.permit(:email, :first_name, :last_name, :company, :website)
      validated_params = Api::Schema::NewContact.call(validated_params.to_h.symbolize_keys)
      return render(json: validated_params.errors.to_h, status: :bad_request) if validated_params.failure?

      contact = Contact.new(validated_params.to_h)
      return render status: :bad_request unless contact.valid?

      contact.save!
      render json: format(contact.attributes)
    end

    def destroy
      validated_params = params.permit(:email)
      validated_params = Schema::DeleteContact.call(validated_params.to_h.symbolize_keys)
      return render(json: validated_params.errors.to_h, status: :bad_request) if validated_params.failure?

      Contact.find_by(email: validated_params[:email])&.destroy!

      render status: :ok
    end

    def format(json)
      {
        "data": {
          "attributes": json
        }
      }
    end
  end
end
