module SEOTool
  class Link
    attr_reader :href, :content, :target, :rel

    def initialize(href, content, rel, target)
      @href    = href
      @content = content
      @rel     = (rel.nil?    || rel.empty?)    ? 'None' : rel
      @target  = (target.nil? || target.empty?) ? 'None' : target
    end
  end
end
