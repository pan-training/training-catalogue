var Bcontributors = {
    add: function (firstname, lastname, contribtype, orcid) {
        var newForm = $('#bcontributor-template').clone().html();

        // Ensure the index of the new form is 1 greater than the current highest index, to prevent collisions
        var index = 0;
        
        $('#bcontributors-list .bcontributor-form').each(function () {
            var newIndex = parseInt($(this).data('index'));
            
        //console.log("index");
        //console.log($(this).data('index'));
            
            if (newIndex > index) {
                index = newIndex;
            }
        });
        // Replace the placeholder index with the actual index
        newForm = $(newForm.replace(/replace-me-bcontributor/g, index + 1));
        newForm.appendTo('#bcontributors-list');

        if (typeof firstname !== 'undefined' && typeof lastname !== 'undefined' && typeof orcid !== 'undefined' && typeof contribtype !== 'undefined') {
            $('.form-control bcontributor-firstname', newForm).val(firstname);
            $('.form-control bcontributor-lastname', newForm).val(lastname);
            $('.form-control bcontributor-contribtype', newForm).val(contribtype);            
            $('.form-control bcontributor-orcid', newForm).val(orcid);
        }

        var event = jQuery.Event( "logged_contributor" );
        event.orcidindex = index+1;
        newForm.trigger(event);
      
        console.log("event launched");
      
        //newForm.trigger('myname.loaded');      // trigger event on new element

        return false; // Stop form being submitted
    },

    // This is just cosmetic. The actual removal is done by rails,
    //   by virtue of the hidden checkbox being checked when the label is clicked.
    delete: function () {
        $(this).parents('.bcontributor-form').fadeOut();
    }
};

document.addEventListener("turbolinks:load", function() {
    $('#bcontributors')
        .on('click', '#add-bcontributor-btn', Bcontributors.add)
        .on('change', '.delete-bcontributor-btn input.destroy-attribute', Bcontributors.delete);
        
        
});





