// Placeholder manifest file.
// the installer will append this file to the app vendored assets here: vendor/assets/javascripts/spree/backend/all.js'

check_status = function(){
  if ( $('.active-waiter-container') ) {
    console.log('check_status', $('.active-waiter-container').data('url'))

    setTimeout(function() {
      $.getScript($('.active-waiter-container').data('url'))
    }, 2000);
  }
}

$(document).ready(function(){
  $('.export-logs a.plus').on('click', function(event){

    message = $(this).parent().parent().data('message')

    $('.export-logs .' + message +  ' a.plus').addClass('dn');

    $('.export-logs .' + message +  ' a.minus').removeClass('dn');
    $('.export-logs .' + message +  '.log-data').removeClass('dn');
    $('.export-logs .' + message +  '.log-backtrace').removeClass('dn');
  });

  $('.export-logs a.minus').on('click', function(event){

    message = $(this).parent().parent().data('message')

    $('.export-logs .' + message +  ' a.plus').removeClass('dn');

    $('.export-logs .' + message +  ' a.minus').addClass('dn');
    $('.export-logs .' + message +  '.log-data').addClass('dn');
    $('.export-logs .' + message +  '.log-backtrace').addClass('dn');
  });

  check_status();
});
