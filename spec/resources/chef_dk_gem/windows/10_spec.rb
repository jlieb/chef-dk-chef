# encoding: utf-8
# frozen_string_literal: true

require_relative '../windows'

describe 'resources::chef_dk_gem::windows::10' do
  include_context 'resources::chef_dk_gem::windows'

  let(:platform) { 'windows' }
  let(:platform_version) { '10' }

  it_behaves_like 'any Windows platform'
end
