//= require active_admin/base
$(document).ready(function() {
  // Handle image removal
  $(document).on('click', '.remove-image', function() {
    const imageUrl = this.getAttribute('data-url');
    const removedImagesInput = $('#product_removed_images');
    const removedImages = removedImagesInput.val() ? removedImagesInput.val().split(',') : [];
    removedImages.push(imageUrl);
    removedImagesInput.val(removedImages.join(','));
    $(this).parent().remove();
  });
});