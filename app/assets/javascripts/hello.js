$(document).ready(function(){
  $('#rqs-listing').on('click', '.show-raw-rq-btn', function(){
    var rq_id = $(this).data('rq-id');
    $('#rq-raw-id-' + rq_id).toggleClass('hidden');
    });
  $('#rqs-listing').on('ajax:success', '.delete-rq', function(e,data,status,xhr){
    $('#rqs-listing').html(data);
  });
});
