import { Controller } from "@hotwired/stimulus"

// モーダルの制御
export default class extends Controller {
  // 背景クリックでモーダルを閉じる
  close() {
    // Turbo Frameの中身を空にしてモーダルを非表示
    // remove()だとTurbo Frameごと削除されて2回目以降表示されなくなる
    this.element.innerHTML = ""
  }
}
