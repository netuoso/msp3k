(function() {
  var $;

  $ = jQuery;

  $(document).on("click", "#list input.toggle", function() {
    return $("#list [name='bulk_ids[]']").prop("checked", $(this).is(":checked"));
  });

  $(document).on('click', '.pjax', function(event) {
    if (event.which > 1 || event.metaKey || event.ctrlKey) {

    } else if ($.support.pjax) {
      event.preventDefault();
      return $.pjax({
        container: $(this).data('pjax-container') || '[data-pjax-container]',
        url: $(this).data('href') || $(this).attr('href'),
        timeout: 2000
      });
    } else if ($(this).data('href')) {
      return window.location = $(this).data('href');
    }
  });

  $(document).on('submit', '.pjax-form', function(event) {
    if ($.support.pjax) {
      event.preventDefault();
      return $.pjax({
        container: $(this).data('pjax-container') || '[data-pjax-container]',
        url: this.action + (this.action.indexOf('?') !== -1 ? '&' : '?') + $(this).serialize(),
        timeout: 2000
      });
    }
  });

  $(document).on('pjax:start', function() {
    return $('#loading').show();
  }).on('pjax:end', function() {
    return $('#loading').hide();
  });

  $(document).on('click', '[data-target]', function() {
    if (!$(this).hasClass('disabled')) {
      if ($(this).has('i.icon-chevron-down').length) {
        $(this).removeClass('active').children('i').toggleClass('icon-chevron-down icon-chevron-right');
        return $($(this).data('target')).select(':visible').hide('slow');
      } else {
        if ($(this).has('i.icon-chevron-right').length) {
          $(this).addClass('active').children('i').toggleClass('icon-chevron-down icon-chevron-right');
          return $($(this).data('target')).select(':hidden').show('slow');
        }
      }
    }
  });

  $(document).on('click', '.form-horizontal legend', function() {
    if ($(this).has('i.icon-chevron-down').length) {
      $(this).siblings('.control-group:visible').hide('slow');
      return $(this).children('i').toggleClass('icon-chevron-down icon-chevron-right');
    } else {
      if ($(this).has('i.icon-chevron-right').length) {
        $(this).siblings('.control-group:hidden').show('slow');
        return $(this).children('i').toggleClass('icon-chevron-down icon-chevron-right');
      }
    }
  });

  $(document).on('click', 'form .tab-content .tab-pane a.remove_nested_one_fields', function() {
    return $(this).children('input[type="hidden"]').val($(this).hasClass('active')).siblings('i').toggleClass('icon-check icon-trash');
  });

  $(document).ready(function() {
    return $(document).trigger('rails_admin.dom_ready');
  });

  $(document).on('pjax:end', function() {
    return $(document).trigger('rails_admin.dom_ready');
  });

  $(document).on('rails_admin.dom_ready', function() {
    $('.animate-width-to').each(function() {
      var length, width;
      length = $(this).data("animate-length");
      width = $(this).data("animate-width-to");
      return $(this).animate({
        width: width
      }, length, 'easeOutQuad');
    });
    $('.form-horizontal legend').has('i.icon-chevron-right').each(function() {
      return $(this).siblings('.control-group').hide();
    });
    $(".table").tooltip({
      selector: "th[rel=tooltip]"
    });
    return $('[formnovalidate]').on('click', function() {
      return $(this).closest('form').attr('novalidate', true);
    });
  });

  $(document).on('click', '#fields_to_export label input#check_all', function() {
    var elems;
    elems = $('#fields_to_export label input');
    if ($('#fields_to_export label input#check_all').is(':checked')) {
      return $(elems).prop('checked', true);
    } else {
      return $(elems).prop('checked', false);
    }
  });

  $(document).on('pjax:popstate', function() {
    $(document).one('pjax:end', function(event) {
      $(event.target).find('script').each(function() {
        $.globalEval(this.text || this.textContent || this.innerHTML || '');
      });
    });
  });

  $(document).on('click', "#remove_filter", function(event) {
    event.preventDefault();
    $("#filters_box").html("");
    $("hr.filters_box").hide();
    $(this).parent().siblings("input[type='search']").val("");
    return $(this).parents("form").submit();
  });

}).call(this);
