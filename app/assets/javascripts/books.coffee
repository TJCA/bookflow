# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery(document).ready ->
  jQuery('#book_form').submit ->
    total = 1.0
    cd_cost = if jQuery('#cd_lost').is(':checked') then 0.8 else 1.0
    if jQuery('#type_textbook').is(':checked')
      total = cd_cost
    else if jQuery('#type_outside').is(':checked')
      total = 0.5 * cd_cost
    jQuery('#ratio_item').attr 'value', total
    return