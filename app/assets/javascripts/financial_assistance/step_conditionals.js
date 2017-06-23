$(document).ready(function() {
  

  
  $('#income_kind').on('selectric-change', function(e){
    if ($(this).val() == 'wages_and_salaries')
      toggle_employer_contact_divs('show'); 
    else
      toggle_employer_contact_divs('hide');
  });

  if ($('#income_kind').val() == 'wages_and_salaries'){
    toggle_employer_contact_divs('show');
  }
  else {
    toggle_employer_contact_divs('hide');
  }


  function toggle_employer_contact_divs(hide_show) {
    if (hide_show == 'hide') {
      $('#income_kind').parents(".row").next().next().addClass('hide');
      $('#income_kind').parents(".row").next().next().next().addClass('hide');
      $('#income_kind').parents(".row").next().next().next().next().addClass('hide');
    }
    else {
      $('#income_kind').parents(".row").next().next().removeClass('hide');
      $('#income_kind').parents(".row").next().next().next().removeClass('hide');
      $('#income_kind').parents(".row").next().next().next().next().removeClass('hide');
    }
  }

  // Clear 0 value for Income
  if ($("#income_amount").val() == 0){
   $("#income_amount").val("");
  }

  $("body").on("change", "#is_required_to_file_taxes_no", function(){
    if ($('#is_required_to_file_taxes_no').is(':checked')) {
      $(this).parents(".row").next().addClass('hide');
    }
    else{
      $(this).parents(".row").next().next().removeClass('hide');
    }
  });
  $("body").on("change", "#is_required_to_file_taxes_yes", function(){

    if ($('#is_required_to_file_taxes_yes').is(':checked')) {
      $(this).parents(".row").next().removeClass('hide');
    }
    else{
      $(this).parents(".row").next().next().addClass('hide');
    }
  });

  $("body").on("change", "#is_claimed_as_tax_dependent_no", function(){
    if ($('#is_claimed_as_tax_dependent_no').is(':checked')) {
      $(this).parents(".row").next().addClass('hide');
    }
    else{
      $(this).parents(".row").next().next().removeClass('hide');
    }
  });

  $("body").on("change", "#is_claimed_as_tax_dependent_yes", function(){

    if ($('#is_claimed_as_tax_dependent_yes').is(':checked')) {
      $(this).parents(".row").next().removeClass('hide');
    }
    else{
      $(this).parents(".row").next().next().addClass('hide');
    }
  });

  $("body").on("click", ".interaction-click-control-next-step", function(e){
        var errorMsgs = [];
        var form = $(this).parents("form");
        var $requiredFieldRows = $(this).parents("form").find(".row:not(.hide):not(:last-child)");
        var totalRequiredCount = $requiredFieldRows.length - 1;  // -1 for the last row..
        var totRadioSelected = $(this).parents("form").find(".row:not(.hide) input[type='radio']:checked").length;
        var isValid = totRadioSelected == totalRequiredCount;
        $requiredFieldRows.each(function(index, element) {
            var $this = $(this);
            if($this.find("input[type='radio']").length && !$this.find("input[type='radio']:checked").length) {
                 errorMsgs.push("PLEASE SELECT * " + $this.find("span").text().replace('*', ''));
            } else {
                $this.find(".alert-error").html("");
            }
        });
        if ($(errorMsgs).length > 0){
            $(".alert-error").text(errorMsgs);
            $(".alert-error").removeClass('hide');
        }
        else{
            $(".alert-error").text("");
            $(".alert-error").addClass('hide');
            $(form).submit();

        }
        return isValid;
    });
  /* Benefit Form Related */
  $("body").on("change", "#is_enrolled_no2", function(){
    if ($('#is_enrolled_no2').is(':checked')) {
      $(this).parents(".row").next().addClass('hide');
    };
  });

  $('#is_eligible_no2').click(function() {
    if($('#is_eligible_no2').is(':checked')) { 
      $('#is_eligible_no2').closest("form").find(':input').not("#is_eligible_no2, .commit").val('');
      //TODO: Clear Selectric Dropdown
    }
  });

  $("body").on("change", "#is_enrolled_yes2", function(){
    if ($('#is_enrolled_yes2').is(':checked')) {
      $(this).parents(".row").next().removeClass('hide');
    };
  });

  $("body").on("change", "#is_eligible_no2", function(){
    if ($('#is_eligible_no2').is(':checked')) {
      $(this).parents(".row").next().addClass('hide');
      $(this).parents(".row").next().next().addClass('hide');
      toggle_employer_contact_divs_benefit('hide');
    };
  });

  $("body").on("change", "#is_eligible_yes2", function(){
    if ($('#is_eligible_yes2').is(':checked')) {
      $(this).parents(".row").next().removeClass('hide');
      $(this).parents(".row").next().next().removeClass('hide');
      toggle_employer_contact_divs_benefit('show');
    };
  });

  if($('#is_enrolled_no2').is(':checked')) { 
    $('#is_enrolled_no2').parents(".row").next().addClass('hide');
    //TODO: Clear Selectric Dropdown
  }

  if($('#is_eligible_no2').is(':checked')) { 
    $('#is_eligible_no2').parents(".row").next().addClass('hide');
    $('#is_eligible_no2').parents(".row").next().next().addClass('hide');
    //TODO: Clear Selectric Dropdown
  }

  $('#benefit_kind').on('selectric-change', function(e){
    if ($(this).val() == 'employer_sponsored_insurance')
      toggle_employer_contact_divs_benefit('show');
    else
      toggle_employer_contact_divs_benefit('hide');
  });

  if( $("#kind .label").text() == 'employer_sponsored_insurance'){
    toggle_employer_contact_divs_benefit('show');
  } else {
    toggle_employer_contact_divs_benefit('hide');
  };

  function toggle_employer_contact_divs_benefit(hide_show) {
    if (hide_show == 'show') {
      $('#benefit_kind').parents(".row").next().next().removeClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().removeClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().next().removeClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().next().next().removeClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().next().next().next().removeClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().next().next().next().next().removeClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().next().next().next().next().next().removeClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().next().next().next().next().next().next().removeClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().next().next().next().next().next().next().next().removeClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().next().next().next().next().next().next().next().next().removeClass('hide');
    }
    else {
      $('#benefit_kind').parents(".row").next().next().addClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().addClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().next().addClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().next().next().addClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().next().next().next().addClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().next().next().next().next().addClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().next().next().next().next().next().addClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().next().next().next().next().next().next().addClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().next().next().next().next().next().next().next().addClass('hide');
      $('#benefit_kind').parents(".row").next().next().next().next().next().next().next().next().next().next().next().addClass('hide');
    }
  }

  // Clear 0 value for Benefit
  if ($("#benefit_kind").val() == 0){
   $("#benefit_kind").val("");
  }

  /* Clear ESI Fields on "No" selectoion of is_eligible answer*/
  $('#is_eligible_no2').click(function() {
    if($('#is_eligible_no2').is(':checked')) { 
      $('#kind, #eligible_start_on, #eligible_end_on, #t_kind, #employer_name, #add1, #add2, #city, #state, #zip, #phone, #fein, #amount, #frequency').val('');
      //TODO: Clear Selectric Dropdown
    }
  });

  $("body").on("change", "#is_eligible_no2", function(){
    if ($('#is_eligible_no2').is(':checked')) {
      $('#kind, #eligible_start_on, #eligible_end_on, #t_kind, #employer_name, #add1, #add2, #city, #state, #zip, #phone, #fein, #amount, #frequency').val('');
      //TODO: Clear Selectric Dropdown
    };
  });

  /* Benefit Form Related */
});
