require "childprocess"

require "pvc/block_piece"
require "pvc/null_piece"
require "pvc/process_piece"
require "pvc/with_err_piece"
require "pvc/result"

module PVC
  class Pipeline

    def initialize(*args, &block)
      @pieces = []
      if args.length > 0 || block_given?
        self.to(*args, &block)
      end
    end

    def to(*args, &block)
      if block_given?
        @pieces << BlockPiece.new(&block)
      else
        @pieces << ProcessPiece.new(*args)
      end
      self
    end

    def with_err
      @pieces << WithErrPiece.new
      self
    end

    def run
      padded_pieces = [NullPiece.new] + @pieces + [NullPiece.new]
      
      padded_pieces.zip(padded_pieces[1..-1]).reverse.each do |current, following|
        current.start(following)
      end

      padded_pieces.each do |current|
        current.finish
      end

      Result.new
    end

  end
end

