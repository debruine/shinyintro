$(function() {
  // radio-table functions //
  
  // set default view based on screen width
  $('.radio-table').toggleClass("select-view", window.innerWidth < 600);
  
  // update selectize on radio button change
  $('body').on('click', '.radio-table input',  function(e) {
    e.stopPropagation(); // don't trigger td click
    $(this).parents('tr').find('td').removeClass('checked');
    $(this).parents('td').addClass('checked');
    $('#' + this.name).selectize()[0].selectize.setValue(this.value, false);
  });
  
  // extend clickable region to full cell
  $('body').on('click', '.radio-table td.radio-button', function(e) {
    var ipt = $(this).find("input");
    ipt.click();
  });
  
  // update radio buttons on selectize change
  $('.radio-table select').selectize({
    onChange: function(value) {
      var id = this.$control_input[0].id.replace('-selectized', '');
      $('input[type=radio][name='+id+']').prop('checked', false);
      $('input[type=radio][name='+id+'][value='+value+']').prop('checked', true);
    }
  });

  // toggle table vs select view
  $('body').on('click', '.radio-toggle', function(e) {
    $(this).next('table.radio-table').toggleClass("select-view");
  });
  
  // collapse box by ID
  closeBox = function(boxid) {
    var box = $('#' + boxid).closest('.box');
    if (!box.hasClass('collapsed-box')) {
      box.find('[data-widget=collapse]').click();
    }
  };

  // uncollapse box by ID
  openBox = function(boxid) {
    var box = $('#' + boxid).closest('.box');
    if (box.hasClass('collapsed-box')) {
      box.find('[data-widget=collapse]').click();
    }
  };

  // toggle box on click
  $('.box').on('click', '.box-header h3', function() {
    $(this).closest('.box')
           .find('[data-widget=collapse]')
           .click();
  });

});
