# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery(document).ready ->
  jQuery('#check-btn').click ->
    current_phone = undefined
    phone_regexp = undefined
    phone_regexp = /1[3578]\d{9}/g
    current_phone = jQuery('#phone-field').val()
    if current_phone.search(phone_regexp) != -1
      jQuery.ajax
        url: '/verification'
        async: true
        dataType: 'json'
        type: 'POST'
        success: ->
          jQuery('#verify-field').css 'display', 'block'
          jQuery('#reg-btn').css 'display', 'block'
          jQuery('#check-btn').css 'display', 'none'
          return
        error: ->
          alert '手机号已被占用'
        data: phone: current_phone
    else
      alert '请输入正确的手机号'
    false
  jQuery('#chpwd-form').submit ->
    new_phone = jQuery('#password').val()
    new_phone_cfm = jQuery('#password-confirm').val()
    if new_phone != new_phone_cfm
      alert '两次输入请保持一致！'
      return false
    true
  jQuery('.admin-selector').click ->
    school_id = jQuery(this).data('sid')
    type = jQuery(this).data('op')
    if type == 'enpower'
      confirm_info = '设置'
    else
      confirm_info = '取消'
    if !confirm('确定要' + confirm_info + school_id + '的管理员身份？')
      return
    jQuery.ajax
      url: '/enpowerment'
      async: true
      dataType: 'json'
      type: 'PUT'
      success: (data) ->
        if data.status == 'ok'
          alert('设置成功')
          window.location = '/enpower'
        else
          alert('设置失败')
      error: ->
        alert('设置失败')
      data: sid: school_id, type: type
