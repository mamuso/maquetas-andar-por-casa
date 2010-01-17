module Nanoc
  #Raised in the event of an unsatisified global capture dependency
  class UnsatisfiedGlobalCaptureReference < StandardError
  end
  class Compiler
    attr_accessor :recompiles
    alias :old_run :run
    def run(objects = nil, params = {})
      # Track recursion depth.  We allow a depth of no more
      # than 2. If greater, we have unsatisfied global capture
      # references
      (@depth ||= 0)
      @depth += 1
      if @depth > 2
        raise UnsatisfiedGlobalCaptureReference.new("The following pages have unsatisfied global capture references: #{@recompiles.join(', ')}") 
      end
     
      @recompiles = []
      old_run(objects, params)

      # Recompile stuff that had a global capture miss
      recompile_pages = @recompiles.map do |path|
        @site.pages.find do |site_page|
          check_path = path.gsub('.html', '/')
          site_page.path == check_path
        end
      end
      if recompile_pages.size > 0
        run(recompile_pages, :also_layout => params[:also_layout], :even_when_not_outdated => true, :from_scratch => true)
      end
    end  
  end
end


module ContentFor
  CAPTURES = {}
  def content_for(name, &block)
    if !block.nil?
      captures[name] = capture(&block)
    end
  end

  def get_content_for(name, &block)
      if !captures.has_key?(name)
        @site.compiler.recompiles << @page.path
      end
      captures[name]
  end
  
  def captures
    CAPTURES
  end

  private

  def capture(*args, &block)
    buffer = eval('_erbout', block.binding)

    pos = buffer.length
    block.call(*args)

    data = buffer[pos..-1]

    buffer[pos..-1] = ''

    data
  end
end

include ContentFor
