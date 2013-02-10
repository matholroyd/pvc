module PVC
  class NullBit
    
    def initialize
      @read, @write = IO.pipe
      @read.close_on_exec = true
      @write.close_on_exec = true
    end

    def stdin
      @write
    end

    def start(following=nil)
      # do nothing
    end

    def finish
      @write.close
    end

  end
end

