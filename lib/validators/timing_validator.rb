class TimingValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    begin
      return if options[:allow_nil]   && value.nil?
      return if options[:allow_blank] && value.blank?
      if options[:before] && !(before = record.send(options[:before])).blank? && before < value
        record.errors[attribute] << I18n.t('model.errors.custom.timing.before', other_field: record.class.human_attribute_name(options[:before]))
      end
      if options[:after]  && !(after  = record.send(options[:after])).blank?  && value  < after
        record.errors[attribute] << I18n.t('model.errors.custom.timing.after', other_field: record.class.human_attribute_name(options[:after]))
      end
    end
  end
end
