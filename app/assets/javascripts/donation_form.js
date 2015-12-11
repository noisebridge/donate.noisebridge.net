jQuery(function($) {
  $(".cc-number").payment('formatCardNumber');
  $(".cc-exp").payment('formatCardExpiry');
  $(".cc-cvc").payment('formatCardCVC');

  function displayError(form, error) {
    var template = _.template($("#notice-template").html());
    $('.alerts').prepend(template({
      type: 'danger',
      content: error.message
    }));

    form.find("[data-stripe=" + error.param + "]").closest(".form-group").addClass("has-error");
  };

  function resetErrors(form) {
    form.find(".has-error").removeClass("has-error")
    $('.alerts').empty();
  };

  // Allow for custom amounts when "Other" selected in donation amount dropdown
  $('form.donation-form select').on('change', function(e) {
    var custom_input = $('form.donation-form .custom-amount');
    if ($(e.target).val() == "other") {
      var t = _.template($("#donation-form-custom-amount").html());
      $("form.donation-form .form-group.amount").append(t())
    } else {
      custom_input.remove();
    }
  });

  $('form.donation-form').submit(function(event) {
    var $form = $(this);

    resetErrors($form);

    $form.find('button').prop('disabled', true);

    Stripe.card.createToken({
      number: $form.find(".cc-number").val(),
      cvc: $form.find(".cc-cvc").val(),
      exp_month: $form.find(".cc-exp").payment('cardExpiryVal').month,
      exp_year: $form.find(".cc-exp").payment('cardExpiryVal').year,
      address_zip: $form.find(".cc-zip").val()
    }, function(status, response) {
      if (response.error) {
        displayError($form, response.error);
        $form.find('button').prop('disabled', false);
      } else {
        $form.append($('<input type="hidden" name="donor[stripe_token]" />').val(response.id));
        $form.get(0).submit();
      }
    });

    return false;
  });
});

