// Prevent uploading of big images with I18n support
document.addEventListener("turbo:load", function() {
  document.addEventListener("change", function(event) {
    let image_upload = document.querySelector('#micropost_image');
    if (image_upload && event.target === image_upload && image_upload instanceof HTMLInputElement) {
      const files = image_upload.files;
      if (files && files.length > 0) {
        const file = files[0];
        const size_in_megabytes = file.size/1024/1024;
        const max_size = window.Settings.micropost.max_image_size;
        
        // Check file size
        if (size_in_megabytes > max_size) {
          const errorMessage = I18n.t('javascript.image_upload.file_size_error', {size: max_size});
          alert(errorMessage);
          image_upload.value = "";
          return;
        }
        
        // Check file format
        const validTypes = window.Settings.micropost.allowed_mime_types;
        if (!validTypes.includes(file.type)) {
          const errorMessage = I18n.t('javascript.image_upload.invalid_format');
          alert(errorMessage);
          image_upload.value = "";
        }
      }
    }
  });
});
