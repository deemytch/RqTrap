$(document).ready(function(){
  $('#rqs-listing').on('click', '.show-raw-rq-btn', function(){
    var rq_id = $(this).data('rq-id');
    $('#rq-raw-' + rq_id).toggleClass('hidden');
    });
  $('#rqs-listing').on('ajax:success', '.delete-rq', function(e,data,status,xhr){
    var rq_id = $(this).data('rq-id');
    $('#rqs-listing').html(data);
  });
});
