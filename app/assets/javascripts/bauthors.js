var Bauthors = {
    add: function (firstname, lastname, orcid) {
        var newForm = $('#bauthor-template').clone().html();

        // Ensure the index of the new form is 1 greater than the current highest index, to prevent collisions
        var index = 0;
        
        $('#bauthors-list .bauthor-form').each(function () {
            var newIndex = parseInt($(this).data('index'));
            
        //console.log("index");
        //console.log($(this).data('index'));
            
            if (newIndex > index) {
                index = newIndex;
            }
        });
        // Replace the placeholder index with the actual index
        newForm = $(newForm.replace(/replace-me-bauthor/g, index + 1));
        newForm.appendTo('#bauthors-list');

        if (typeof firstname !== 'undefined' && typeof lastname !== 'undefined' && typeof orcid !== 'undefined') {
            $('.form-control bauthor-firstname', newForm).val(firstname);
            $('.form-control bauthor-lastname', newForm).val(lastname);
            $('.form-control bauthor-orcid', newForm).val(orcid);
        }

        var event = jQuery.Event( "logged" );
        event.orcidindex = index+1;
        newForm.trigger(event);
      
        console.log("event launched");
      
        //newForm.trigger('myname.loaded');      // trigger event on new element

        return false; // Stop form being submitted
    },

    // This is just cosmetic. The actual removal is done by rails,
    //   by virtue of the hidden checkbox being checked when the label is clicked.
    delete: function () {
        $(this).parents('.bauthor-form').fadeOut();
    }
};

document.addEventListener("turbolinks:load", function() {
    $('#bauthors')
        .on('click', '#add-bauthor-btn', Bauthors.add)
        .on('change', '.delete-bauthor-btn input.destroy-attribute', Bauthors.delete);
        
        
});





