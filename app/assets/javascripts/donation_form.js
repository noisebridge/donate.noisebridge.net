jQuery(function($) {
  $(".cc-number").payment('formatCardNumber');
  $(".cc-exp").payment('formatCardExpiry');
  $(".cc-cvc").payment('formatCardCVC');

  $('form.donation-form').submit(function(event) {
    var $form = $(this);

    $form.find('button').prop('disabled', true);

    Stripe.card.createToken({
      number: $form.find(".cc-number").val(),
      cvc: $form.find(".cc-cvc").val(),
      exp_month: $form.find(".cc-exp").payment('cardExpiryVal').month,
      exp_year: $form.find(".cc-exp").payment('cardExpiryVal').year
    }, function(status, response) {
      if (response.error) {
        $form.find('button').prop('disabled', false);
      } else {
        var token = response.id;
        $form.append($('<input type="hidden" name="donor[stripe_token]" />').val(token));
        $form.get(0).submit();
      }
    });

    return false;
  });
});

