// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

const { default: axios } = require("axios");
var jQuery = require('jquery')
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

import { csrfToken } from "rails-ujs"

axios.defaults.headers.common["X-CSRF-Token"] = csrfToken();

Rails.start()
ActiveStorage.start()

require("./slick")


// 「いいね」されていないハートをクリックすると「いいね」される
const listenInactiveHeartEvent = (postId) => {
  $('#inactive-heart').on('click', () => {
    axios.post(`/posts/${postId}/like`)
      .then((response) => {
        if (response.data.status === 'ok') {
          $('#active-heart').removeClass('hidden')
          $('#inactive-heart').addClass('hidden')
        }
      })
      .catch((e) => {
        window.alert('Error')
        console.log(e)
      })
  })
}

// 「いいね」されているハートをクリックすると「いいね」が解除される
const listenActiveHeartEvent = (postId) => {
  $('#active-heart').on('click', () => {
    axios.delete(`/posts/${postId}/like`)
      .then((response) => {
        if (response.data.status === 'ok') {
          $('#active-heart').addClass('hidden')
          $('#inactive-heart').removeClass('hidden')
        }
      })
      .catch((e) => {
        window.alert('Error')
        console.log(e)
      })
  })
}

// いいねされてるか確認して、表示を判定
const handleHeartDisplay = (hasLiked) => {
  if (hasLiked) {
      $('#active-heart').removeClass('hidden')
  } else {
      $('#inactive-heart').removeClass('hidden')
  }
}



document.addEventListener('DOMContentLoaded', () => {
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


  // いいね機能の実装
  axios.get(`/posts/${postId}/like`)
    .then((response) => {
      const hasLiked = response.data.hasLiked
      handleHeartDisplay(hasLiked)
    })

    listenInactiveHeartEvent(postId)
    listenActiveHeartEvent(postId)
});

