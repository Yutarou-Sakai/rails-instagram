// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

var jQuery = require('jquery')
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

import axios from 'axios'
import { csrfToken } from "rails-ujs"

axios.defaults.headers.common["X-CSRF-Token"] = csrfToken();

Rails.start()
ActiveStorage.start()

require("./slick")




document.addEventListener('DOMContentLoaded', () => {
  $('.active-heart').each(function() {
    const postId = $(this).attr('id')
    // console.log(postId)

    // いいねされてるか確認して判定
    const handleHeartDisplay = (hasLiked) => {
      if (hasLiked) {
        $('#' + postId + '.active-heart').removeClass('hidden')
      } else {
        $('#' + postId + '.inactive-heart').removeClass('hidden')
      }
    }

    // いいね判定をもとに、いいねを表示
    axios.get(`/posts/${postId}/like`)
    .then((response) => {
      const hasLiked = response.data.hasLiked
      handleHeartDisplay(hasLiked)
    })
    .catch((e) => {
      console.log(e)
    })

  });

  // 「いいね」されていないハートをクリックすると「いいね」される
  $('.inactive-heart').on('click', () => {
    const postId = $(this).attr('id')
    axios.post(`/posts/${postId}/like`)
      .then((response) => {
        if (response.data.status === 'ok') {
          $('.active-heart').removeClass('hidden')
          $('.inactive-heart').addClass('hidden')
        }
      })
      .catch((e) => {
        console.log(e)
      })
  })

  // 「いいね」されているハートをクリックすると「いいね」が解除される
  $('.active-heart').on('click', () => {
    const postId = $(this).attr('id')
    axios.delete(`/posts/${postId}/like`)
      .then((response) => {
        if (response.data.status === 'ok') {
          $('.active-heart').addClass('hidden')
          $('.inactive-heart').removeClass('hidden')
        }
      })
      .catch((e) => {
        window.alert('Error')
      })
  })





  $(function(){
    $('.profile-avatar-img').on('click', function(){
      $('#upFile').click();
    });
  });

  // アップローダーで選んだファイルをプレビュー表示
  const uploader = document.querySelector('.form-avatar');
  $(uploader).on('change', (e) => {
    $('#avatar-btn').fadeIn()

    const file = uploader.files[0];
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => {
        const image = reader.result;
        document.querySelector('.profile-avatar-img').setAttribute('src', image);
      }
  });
});

