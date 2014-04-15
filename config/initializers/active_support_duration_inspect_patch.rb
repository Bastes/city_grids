ActiveSupport::Duration

class ActiveSupport::Duration
  def inspect
    parts.
      reduce(::Hash.new(0)) { |h,(l,r)| h[l] += r; h }.
      sort_by {|unit,  _ | [:years, :months, :days, :minutes, :seconds].index(unit)}.
      map     {|unit, val| "#{val} #{val == 1 ? unit.to_s.chop : unit.to_s}"}.
      to_sentence(:locale => ::I18n.locale)
  end
end
