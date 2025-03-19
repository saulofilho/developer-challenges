# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Access, type: :model do
  describe 'associations' do
    it { should belong_to(:url) }
  end

  describe 'validations' do
    it { should validate_presence_of(:accessed_at) }
  end
end
