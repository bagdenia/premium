require 'swagger_helper'

describe 'Movements API' do
  path '/users/{id}/movements' do
    get 'Retrieves a user movements' do
      tags 'Movements'
      produces 'application/json', 'application/xml'
      parameter name: :id, in: :path, type: :string

      response '200', 'found' do
        schema type: 'array',
               items: {
                 "description": 'Движения бонусов',
                 "required": %w[
                   name
                   datetime
                   amount
                 ],
                 "properties": {
                   "name": {
                     "type": 'string'
                   },
                   "datetime": {
                     "type": 'string'
                   },
                   "amount": {
                     "type": 'integer'
                   }
                 }
               }

        let(:movement) { create :movement }
        let(:id) { movement.user_id.to_s }

        run_test!
      end

      response '404', 'Movement not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
