module ApplicationHelper
  # フラッシュメッセージのスタイルクラスを返す
  def flash_style_classes(type)
    case type.to_s
    when "notice"
      "bg-green-500"
    when "alert", "error"
      "bg-red-500"
    else
      "bg-blue-500"
    end
  end

  # フラッシュメッセージのアイコンを返す
  def flash_icon(type)
    case type.to_s
    when "notice"
      # svgをrawで埋め込むとセキュリティリスク（XSS）になるので、部分テンプレートに切り出し
      render "shared/flash_icon_success"
    when "alert", "error"
      render "shared/flash_icon_error"
    else
      render "shared/flash_icon_info"
    end
  end
end
