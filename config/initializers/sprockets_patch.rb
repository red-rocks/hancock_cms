require 'sprockets/directive_processor'

class Sprockets::DirectiveProcessor
  def _call(input)

    @environment  = input[:environment]
    @uri          = input[:uri]
    @filename     = input[:filename]
    @dirname      = File.dirname(@filename)
    @content_type = input[:content_type]
    @required     = Set.new(input[:metadata][:required])
    @stubbed      = Set.new(input[:metadata][:stubbed])
    @links        = Set.new(input[:metadata][:links])
    @dependencies = Set.new(input[:metadata][:dependencies])

    if Hancock.config.erb2coffee_assets.include?(input[:name])
      data, directives = process_source(::ERB.new(input[:data], nil, '-').result)
    else
      data, directives = process_source(input[:data])
    end

    process_directives(directives)

    { data: data,
      required: @required,
      stubbed: @stubbed,
      links: @links,
      dependencies: @dependencies }
  end
end

##### maybe it will help in future

# require "sprockets"
#
# class Hancock::ErbToCoffeeSprocketsExtension
#   def initialize(filename, &block)
#     @filename = filename
#     @source   = block.call
#   end
#
#   def render(context, empty_hash_wtf)
#     self.class.run(@filename, @source, context)
#   end
#
#   def self.run(filename, source, context)
#     puts source if filename =~ /plugins/i
#     result = ::ERB.new(source, nil, '-').result
#     puts "VVVVVVVVVVVVVVV" if filename =~ /plugins/i
#     puts result if filename =~ /plugins/i
#     puts "" if filename =~ /plugins/i
#     puts "" if filename =~ /plugins/i
#     result
#   end
#
#   def self.call(input)
#     filename = input[:filename]
#     source   = input[:data]
#     context  = input[:environment].context_class.new(input)
#
#     result = run(filename, source, context)
#     context.metadata.merge(data: result)
#   end
# end
#
# require 'sprockets/processing'
# # extend Sprockets::Processing
#
# # Sprockets.unregister_preprocessor('text/coffeescript', Sprockets::DirectiveProcessor)
# # Sprockets.register_preprocessor('text/coffeescript', Sprockets::DirectiveProcessor.new(comments: ["#", ["###", "###"]]))
# # Sprockets.register_preprocessor 'text/coffeescript', :erb_to_coffee do |context, data|
# #   puts data.inspect
# # end
#
# Sprockets.unregister_preprocessor('text/coffeescript', Sprockets::DirectiveProcessor)
# Sprockets::register_preprocessor 'application/javascript', Hancock::ErbToCoffeeSprocketsExtension
# # Sprockets::register_preprocessor 'text/coffeescript', Hancock::ErbToCoffeeSprocketsExtension
# Sprockets.register_preprocessor('text/coffeescript', Sprockets::DirectiveProcessor.new(comments: ["#", ["###", "###"]]))
#
# puts Sprockets.preprocessors
#
# # require 'sprockets'
# # require 'sprockets/context'
# # require 'sprockets/erb_processor'
# # class Sprockets::ERBProcessor
# #   def call(input)
# #     if input[:filename] =~ /(plugins|cms)/
# #       puts "___"
# #       puts input[:data]
# #       engine = ::ERB.new(input[:data], nil, '%')
# #       puts "VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV"
# #       puts Sprockets::CoffeeScriptProcessor::VERSION
# #       puts engine.result
# #       puts ""
# #       puts ""
# #     else
# #       engine = ::ERB.new(input[:data], nil, '-')
# #     end
# #     if Sprockets::CoffeeScriptProcessor::VERSION == "2"
# #       engine.filename = input[:filename]
# #       context = input[:environment].context_class.new(input)
# #       klass = (class << context; self; end)
# #       klass.const_set(:ENV, context.env_proxy)
# #       klass.class_eval(&@block) if @block
# #       data = engine.result(context.instance_eval('binding'))
# #       context.metadata.merge(data: data)
# #
# #     elsif Sprockets::CoffeeScriptProcessor::VERSION == "1"
# #       engine = ::ERB.new(input[:data], nil, '<>')
# #       context = input[:environment].context_class.new(input)
# #       klass = (class << context; self; end)
# #       klass.class_eval(&@block) if @block
# #       engine.def_method(klass, :_evaluate_template, input[:filename])
# #       data = context._evaluate_template
# #       context.metadata.merge(data: data)
# #     end
# #
# #   end
# # end
# #
# # require 'sprockets/coffee_script_processor'
# # module Sprockets
# #   module CoffeeScriptProcessor
# #
# #     def self.call(input)
# #       data = input[:data]
# #       puts "CoffeeScriptProcessor"
# #       puts VERSION
# #       puts input.inspect
# #       puts data.inspect
# #       puts
# #       puts
# #       if VERSION == "2"
# #
# #         js, map = input[:cache].fetch([self.cache_key, data]) do
# #           result = Autoload::CoffeeScript.compile(
# #             data,
# #             sourceMap: true,
# #             sourceFiles: [File.basename(input[:filename])],
# #             generatedFile: input[:filename]
# #           )
# #           [result['js'], JSON.parse(result['v3SourceMap'])]
# #         end
# #
# #         map = SourceMapUtils.format_source_map(map, input)
# #         map = SourceMapUtils.combine_source_maps(input[:metadata][:map], map)
# #
# #         { data: js, map: map }
# #
# #       elsif VERSION == "1"
# #         input[:cache].fetch([self.cache_key, data]) do
# #         Autoload::CoffeeScript.compile(data)
# #       end
# #
# #       end
# #
# #     end
# #   end
# # end
