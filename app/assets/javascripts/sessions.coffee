# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery(document).ready ->
  jQuery('#send_msg').click ->
    school_id = jQuery('#school_id').val()
    if school_id.length == 0
      alert('学号不得为空')
      return
    jQuery.post '/login/ask-code', { sid: school_id  },
      (data, status) ->
        if data.status == 'ok'
          jQuery('.before-verify').hide()
          jQuery('.after-verify').removeAttr('hidden')
        else
          alert('获取验证码失败！')