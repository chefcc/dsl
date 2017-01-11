module ModablesDSL
  module DSL
    class Args
      attr_reader :args_h

      def initialize
        @args_h = Hash.new
      end

      def property meth, *args, &block

        # If a block is passed it means we are building a hash.
        if block

          # If a :list is passed build an array of hashes and do not overwrite.
          if args.include? :list
            @args_h[meth] = Array.new if @args_h[meth].nil?

            if args.include? :json
              @args_h[meth] << ActiveSupport::JSON.encode(ModablesDSL::DSL.arguments(&block))
            else
              @args_h[meth] << ModablesDSL::DSL.arguments(&block)
            end

          # Else build a regular hash and overwrite with latest declaration.
          else
            if args.include? :json
              @args_h[meth] = ActiveSupport::JSON.encode(ModablesDSL::DSL.arguments(&block))
            else
              @args_h[meth] = ModablesDSL::DSL.arguments(&block)
            end
          end

        # Else its a String, Integer, Boolean or Array.
        else
          if args.include? :json
            @args_h[meth] = ActiveSupport::JSON.encode(args.last)
          else
            @args_h[meth] = args.last
          end
        end

      end

      # Account for all possible arguments.
      def method_missing meth, *args, &block
        property meth, *args, &block
      end

      # For some reason if #test is not defined explicitly the DSL errors.
      def test *args, &block
        property 'test', *args, &block
      end

    end
  end
end