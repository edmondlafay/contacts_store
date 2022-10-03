module Api
  module Schema
    DeleteContact = Dry::Schema.Params do
      required(:email).filter(format?: Contact::EMAIL_FORMAT)
    end
  end
end
