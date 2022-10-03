module Api
  module Schema
    NewContact = Dry::Schema.Params do
      required(:email).filter(format?: Contact::EMAIL_FORMAT)
      required(:first_name).filled(:string)
      required(:last_name).filled(:string)
      required(:company).filled(:string)
      optional(:website).array(:string)
    end
  end
end
