// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

// Donation form
jQuery(function($) {
  $("#donation_form .cc-number").payment('formatCardNumber');
  $("#donation_form .cc-exp").payment('formatCardExpiry');
  $("#donation_form .cc-cvc").payment('formatCardCVC');


  $('#donation_form').submit(function(event) {
    var $form = $(this);

    // Disable the submit button to prevent repeated clicks
    $form.find('button').prop('disabled', true);

    Stripe.card.createToken({
      number: $("#donation_form .cc-number").val(),
      cvc: $("#donation_form .cc-cvc").val(),
      exp_month: $("#donation_form .cc-exp").payment('cardExpiryVal').month,
      exp_year: $("#donation_form .cc-exp").payment('cardExpiryVal').year
    }, stripeResponseHandler);

    // Prevent the form from submitting with the default action
    return false;
  });
});

function stripeResponseHandler(status, response) {
  var $form = $('#donation_form');

  if (response.error) {
    // Show the errors on the form
    // $form.find('.payment-errors').text(response.error.message);
    $form.find('button').prop('disabled', false);
  } else {
    // response contains id and card, which contains additional card details
    var token = response.id;
    // Insert the token into the form so it gets submitted to the server
    $form.append($('<input type="hidden" name="donor[stripe_token]" />').val(token));
    // and submit
    $form.get(0).submit();
  }
};
