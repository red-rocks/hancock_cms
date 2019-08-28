module Hancock
  module Models
    module Mongoid
      module EmbeddedElement
        extend ActiveSupport::Concern

        include Hancock::EmbeddedFindable

        included do
          field :name, type: String, localize: Hancock.configuration.localize, default: ""

          # stolen from https://github.com/mongoid/mongoid-history/blob/master/lib/mongoid/history/trackable.rb#L171
          def embed_method_for_parent
            ret = nil
            if self._parent
    
              ret = if ::Mongoid::Compatibility::Version.mongoid6_or_older?
                self._parent.relations.values.find do |relation|
                  if ::Mongoid::Compatibility::Version.mongoid3_or_older?
                    relation.class_name == self.metadata.class_name.to_s && relation.name == self.metadata.name
    
                  elsif ::Mongoid::Compatibility::Version.mongoid6_or_older?
                    relation.class_name == self.relation_metadata.class_name.to_s &&
                    relation.name == self.relation_metadata.name
    
                  else
                    false
                  end
                end
    
              else
                _association
              end
            end
            ret and ret.name
          end

          def to_param
            (super or id.to_s) rescue id.to_s
          end

        end


        class_methods do
          def belongs_to(name, options = {}, &block)
            options[:class_name] ||= name.to_s.camelize
            field_name = "#{name}_id"
            field field_name, type: BSON::ObjectId
            class_eval <<-RUBY
              def #{name}
                ::#{options[:class_name]}.find(self.#{field_name}) if self.#{field_name}
              end
              def #{name}=(val)
                self.#{field_name} = (val ? val._id : nil)
              end
            RUBY
          end
    
          def has_and_belongs_to_many(name, options = {}, &block)
            singular_name = name.to_s.singularize
            options[:class_name] ||= singular_name.camelize
            # options[:inverse_of] = self.name.camelize unless options[:inverse_of].nil?
            field_name = "#{singular_name}_ids"
            field field_name, type: Array, default: []
            class_eval <<-RUBY
              def #{name}
                ::#{options[:class_name]}.where(:id.in => self.#{field_name}) if self.#{field_name}
              end
              def #{name}=(val)
                self.#{field_name} = Array(val).map(&:_id).map(&:to_s)
              end
              def remove_#{singular_name}(val)
                val_id = val.is_a?(::#{options[:class_name]}) ? val._id.to_s : val.to_s
                bson_val = BSON::ObjectId.from_string(val_id)
                self.#{field_name}.delete(val_id) or self.#{field_name}.delete(bson_val)
              end
              def add_#{singular_name}(val)
                val_id = val.is_a?(::#{options[:class_name]}) ? val._id.to_s : val.to_s
                bson_val = BSON::ObjectId.from_string(val_id)
                # self.#{field_name} << val_id
                self.#{field_name} << bson_val
                self.#{field_name} = self.#{field_name}.uniq
              end
              # def #{name}<<(val)
              #   self.#{field_name} = (self.#{field_name} + val.id).uniq if val
              # end
            RUBY
          end
    
          def has_many(name, options = {}, &block)
            has_and_belongs_to_many(name, options, &block)
          end
          # def has_one(name, options = {}, &block)
          #   # has_and_belongs_to_many(name, options, &block)
          #   belongs_to(name, options, &block)
          #   accepts_nested_attributes_for name
          # end
        
        end

      end
    end
  end
end
