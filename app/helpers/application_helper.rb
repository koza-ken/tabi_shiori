module ApplicationHelper
  def flash_style_classes(type)
    case type.to_s
    when "notice"
      "bg-green-500"
    when "alert"
      "bg-red-500"
    when "error"
      "bg-red-500"
    else
      "bg-blue-500"
    end
  end
end
