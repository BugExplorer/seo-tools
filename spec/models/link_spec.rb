require 'spec_helper'

RSpec.describe SEOTool::Link do
  context 'with empty rel' do
    _link = SEOTool::Link.new('test.com', 'test', '', '_blank')
    it do
      expect(_link.rel).to eq 'None'
    end
  end

  context 'with empty target' do
    _link = SEOTool::Link.new('test.com', 'test', 'rel', '')
    it do
      expect(_link.target).to eq 'None'
    end
  end

  context 'with nil rel' do
    _link = SEOTool::Link.new('test.com', 'test', nil, '_blank')
    it do
      expect(_link.rel).to eq 'None'
    end
  end

  context 'with nil target' do
    _link = SEOTool::Link.new('test.com', 'test', 'rel', nil)
    it do
      expect(_link.target).to eq 'None'
    end
  end
end
