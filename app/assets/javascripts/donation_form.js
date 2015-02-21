jQuery(function($) {
  $(".cc-number").payment('formatCardNumber');
  $(".cc-exp").payment('formatCardExpiry');
  $(".cc-cvc").payment('formatCardCVC');

  function displayError(form, error) {
    var template = _.template($("#notice-template").html());
    form.prepend(template({
      type: 'danger',
      content: error.message
    }));

    form.find("[data-stripe=" + error.param + "]").closest(".form-group").addClass("has-error");
  };

  function resetErrors(form) {
    form.find(".has-error").removeClass("has-error")
    form.find(".alert").remove();
  };

  // Allow for custom amounts when "Other" selected in donation amount dropdown
  $('form.donation-form select[name="charge[amount]"]').on('change', function(e) {
    var custom_input = $('form.donation-form .custom-amount');
    if ($(e.target).val() == "other") {
      var t = _.template($("#donation-form-custom-amount").html());
      $("form.donation-form .form-group.amount").append(t())
    } else {
      custom_input.remove();
    }
  });
});

