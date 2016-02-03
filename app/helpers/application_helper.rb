module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type
      when :success then "alert-success" # Green
      when :error then "alert-danger"    # Red
      when :alert then "alert-warning"   # Yellow
      when :notice then "alert-info"     # Blue
      else
        flash_type.to_s
    end
  end
end
