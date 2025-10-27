module ApplicationHelper
  # フラッシュメッセージのスタイルクラスを返す
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

  # フラッシュメッセージのアイコンを返す
  def flash_icon(type)
    case type.to_s
    when "notice"
      # チェックマークアイコン（成功）
      raw '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>'
    when "alert", "error"
      # 警告アイコン（エラー）
      raw '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
      </svg>'
    else
      # 情報アイコン（その他）
      raw '<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>'
    end
  end
end
