import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["preview", "urlInput", "typeInput", "thumbnailInput", "uploadButton", "placeholder"]
  static values = {
    cloudName: String,
    uploadPreset: String
  }

  connect() {
    this.widget = null
  }

  open() {
    if (!this.widget) {
      this.widget = cloudinary.createUploadWidget(
        {
          cloudName: this.cloudNameValue,
          uploadPreset: this.uploadPresetValue,
          sources: ["local", "camera"],
          multiple: false,
          maxFileSize: 50000000, // 50MB
          resourceType: "auto",
          clientAllowedFormats: ["jpg", "jpeg", "png", "gif", "webp", "mp4", "webm", "mov"],
          cropping: false,
          showPoweredBy: false,
          language: "ko",
          text: {
            ko: {
              or: "또는",
              menu: {
                files: "내 기기에서",
                camera: "카메라"
              },
              local: {
                browse: "파일 선택",
                dd_title_single: "여기에 파일을 끌어다 놓으세요"
              }
            }
          }
        },
        (error, result) => {
          if (!error && result && result.event === "success") {
            this.handleUploadSuccess(result.info)
          }
        }
      )
    }

    this.widget.open()
  }

  handleUploadSuccess(info) {
    // Set form values
    this.urlInputTarget.value = info.secure_url
    this.typeInputTarget.value = info.resource_type === "video" ? "video" : "image"

    // Set thumbnail for videos
    if (info.resource_type === "video" && this.hasThumbnailInputTarget) {
      // Generate video thumbnail URL
      const thumbnailUrl = info.secure_url.replace(/\.[^/.]+$/, ".jpg")
      this.thumbnailInputTarget.value = thumbnailUrl
    }

    // Update preview
    this.updatePreview(info)
  }

  updatePreview(info) {
    if (this.hasPlaceholderTarget) {
      this.placeholderTarget.classList.add("hidden")
    }

    if (this.hasPreviewTarget) {
      this.previewTarget.classList.remove("hidden")

      if (info.resource_type === "video") {
        this.previewTarget.innerHTML = `
          <video src="${info.secure_url}" controls class="max-h-64 rounded-lg mx-auto">
            Your browser does not support the video tag.
          </video>
          <p class="text-sm text-green-400 mt-2">동영상 업로드 완료!</p>
        `
      } else {
        this.previewTarget.innerHTML = `
          <img src="${info.secure_url}" alt="Preview" class="max-h-64 rounded-lg mx-auto">
          <p class="text-sm text-green-400 mt-2">이미지 업로드 완료!</p>
        `
      }
    }

    // Update button text
    if (this.hasUploadButtonTarget) {
      this.uploadButtonTarget.textContent = "다른 파일 선택"
    }
  }
}
