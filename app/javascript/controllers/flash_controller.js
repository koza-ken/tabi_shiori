import { Controller } from "@hotwired/stimulus"

// フラッシュメッセージ（ポップアップ通知）の制御
export default class extends Controller {
  connect() {
    // 表示アニメーション：右上からスライドイン
    this.show()

    // 3秒後に自動で非表示
    this.timeout = setTimeout(() => {
      this.hide()
    }, 3000)
  }

  // 表示アニメーション
  show() {
    // 初期状態：透明で右側にオフセット
    this.element.style.opacity = "0"
    this.element.style.transform = "translateX(100%)"

    // 少し待ってからアニメーション開始（CSSトランジションを有効にするため）
    requestAnimationFrame(() => {
      this.element.style.opacity = "1"
      this.element.style.transform = "translateX(0)"
    })
  }

  // 非表示アニメーション
  hide() {
    // フェードアウト
    this.element.style.opacity = "0"
    this.element.style.transform = "translateX(100%)"

    // アニメーション完了後にDOMから削除
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }

  // ユーザーが×ボタンをクリックしたとき
  close() {
    // タイムアウトをキャンセル
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
    this.hide()
  }

  // コントローラーが削除されるときにクリーンアップ
  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }
}
