module AssociationReporting

  def describe(association)
    reflection = self.reflect_on_association(association)
    raise "Can't find an association #{self.name}##{association}" if reflection.nil?

    if reflection.is_a? ActiveRecord::Reflection::ThroughReflection
      describe_through_reflection(reflection)
    else
      describe_reflection(reflection)
    end
  end

  private

  def describe_reflection(reflection)
    association_class_assumption = check_model_class(reflection.class_name)
    association_table_assumption = check_model_table(reflection.class_name)
    fkey_table_assumption = check_model_table(one_to_many_fkey_model(reflection))
    fkey_assumption = check_column(fkey_table_assumption[:table], reflection.foreign_key)

    puts_indent ""
    puts association_description(reflection.name)
    puts_indent "This '#{association_name(reflection)}' association is looking for a column called '#{fkey_assumption[:label]}' on the table '#{fkey_table_assumption[:label]}'."
    print "  It's expecting to return "
    print reflection.collection? ? "a collection of " : "a "
    print "#{association_class_assumption[:label]} object#{reflection.collection? ? "s":""} "
    print "from the #{association_table_assumption[:label]} table.\n"

    puts_indent ""
    valid_association = association_class_assumption[:valid] &&
                        association_table_assumption[:valid] &&
                        fkey_table_assumption[:valid] &&
                        fkey_assumption[:valid]
    puts_indent "#{feelings(valid_association)}"
    puts_indent ""
  end

   def describe_through_reflection(reflection)
    through_assoc_assumption = check_association(self, reflection.options[:through])
    through_class_assumption = check_model_class(reflection.through_reflection.try(:class_name))
    if through_class_assumption[:valid]
      source_name = reflection.source_reflection_names.first.to_s
      source_assoc_assumption = check_association(through_class_assumption[:class], source_name)
      if source_assoc_assumption[:valid]
        source_class_assumption = check_model_class(reflection.class_name)
        source_table_assumption = check_model_table(reflection.class_name)
      end
    end

    puts_indent ""
    puts association_description(reflection.name)
    puts_indent "This '#{association_name(reflection)}' association is looking for another association called #{self.to_s}##{through_assoc_assumption[:label]} to jump through."
    if through_assoc_assumption[:valid]
      puts_indent "It will go through the association '#{self.to_s}##{through_assoc_assumption[:label]}' to the model #{through_class_assumption[:label]}."
      if through_class_assumption[:valid]
        print "  When it gets to #{through_class_assumption[:label]} it "
        if source_assoc_assumption[:valid]
          print "will jump through a source association called #{through_class_assumption[:label].to_s}##{source_assoc_assumption[:label]}.\n"
          puts_indent "#{through_class_assumption[:label].to_s}##{source_assoc_assumption[:label]} is an association that returns #{source_class_assumption[:label]} objects from the #{source_table_assumption[:label]} table."
        else
          print "will try to jump through an association called #{source_assoc_assumption[:label]}.\n"
        end
      end
    end
    puts_indent ""
    valid_association = through_assoc_assumption[:valid] &&
                        through_class_assumption[:valid] &&
                        source_assoc_assumption[:valid] &&
                        source_class_assumption[:valid] &&
                        source_table_assumption[:valid]



    puts_indent "#{feelings(valid_association)}"
    puts_indent ""
  end

  def puts_indent(v, indent = 2)
    puts (" " * indent) + v
  end

  def association_name(reflection)
    case reflection
    when ActiveRecord::Reflection::HasManyReflection
      "has_many"
    when ActiveRecord::Reflection::BelongsToReflection
      "belongs_to"
    when ActiveRecord::Reflection::HasOneReflection
      "has_one"
    when ActiveRecord::Reflection::ThroughReflection
      "has_many :through"
    else
      ""
    end
  end

  def association_description(name)
    "Describing the association #{self.to_s}##{name}:"
  end

  def feelings(valid_association)
    "This association is feeling #{valid_association ? '😃' : '😢'}"
  end

  def one_to_many_fkey_model(reflection)
    if reflection.is_a?(ActiveRecord::Reflection::BelongsToReflection)
      self.to_s
    else
      reflection.class_name
    end
  end

  def check_model_class(class_name)
    class_exists = class_name && class_name.present? && Object.const_defined?(class_name)
    klass = class_exists ? Object.const_get(class_name) : nil
    {
      label: label(class_name, class_exists),
      class: klass,
      valid: class_exists
    }
  end

  def check_model_table(class_name)
    model_table = class_name && class_name.underscore.pluralize
    table_exists = model_table && ActiveRecord::Base.connection.table_exists?(model_table)
    {
      label: label(model_table, table_exists),
      valid: table_exists,
      table: model_table
    }
  end

  def check_column(table_name, column)
    column_exists = ActiveRecord::Base.connection.table_exists?(table_name) &&
                    ActiveRecord::Base.connection.column_exists?(table_name, column)
    {
      label: label(column, column_exists),
      valid: column_exists
    }
  end

  def check_association(klass, association_name)
    exists = klass.method_defined?(association_name)
    {
      label: label(association_name.to_s, exists),
      valid: exists
    }
  end

  def label(str, cond)
    str && str.colorize(cond ? :green : :red)
  end
end
