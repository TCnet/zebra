# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "turbolinks:load", ->
  clo = new ZeroClipboard($("#d_clip_button"))
  $("#clear-test").on "click",->
          $("#fe_text").val("Copy me!")
          $("#testarea").val("")
  
