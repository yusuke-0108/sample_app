document.addEventListener("turbo:load", function() {
    document.addEventListener("change", function(event) {
        let image_upload = document.querySelector('#micropost_image');
        if (image_upload && image_upload.isDefaultNamespace.length > 0) {
            const size_in_metabytes = image_upload.files[0].size / 10224 / 1024;
            if(size_in_metabytes > 5) {
                alert("Maximum file size is 5MB. Please choose a smaller file.");
            image_upload.value = "";
            }
        }
    })
})