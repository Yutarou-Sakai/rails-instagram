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



// いいねされてるか確認して判定
const handleHeartDisplay = (hasLiked, postId) => {
  if (hasLiked) {
    $('#' + postId + '.active-heart').removeClass('hidden')
  } else {
    $('#' + postId + '.inactive-heart').removeClass('hidden')
  }
}

// 「いいね」されていないハートをクリックすると「いいね」される
const listenInactiveHeartEvent = (postId) => {
  $('#' + postId + '.inactive-heart').on('click', () => {
    axios.post(`/posts/${postId}/like`)
      .then((response) => {
        if (response.data.status === 'ok') {
          $('#' + postId + '.active-heart').removeClass('hidden')
          $('#' + postId + '.inactive-heart').addClass('hidden')
        }
      })
      .catch((e) => {
        console.log(e)
      })
  })
}

// 「いいね」されているハートをクリックすると「いいね」が解除される
const listenActiveHeartEvent = (postId) => {
  $('#' + postId + '.active-heart').on('click', () => {
    axios.delete(`/posts/${postId}/like`)
      .then((response) => {
        if (response.data.status === 'ok') {
          $('#' + postId + '.active-heart').addClass('hidden')
          $('#' + postId + '.inactive-heart').removeClass('hidden')
        }
      })
      .catch((e) => {
        console.log(e)
      })
  })
}



document.addEventListener('DOMContentLoaded', () => {
  // ＝＝＝　いいね機能　＝＝＝
  const dataset = $('#post-show').data()
  const showId = dataset.showId

  if (typeof showId !== 'undefined') {
    axios.get(`/posts/${showId}/comments`)
      .then((response) => {
        const comments = response.data
        comments.forEach((comment) => {
          $('.comment_lists').append(
            `<div class="comment_list">
              <div class="comment_avatar">
                <img src="${comment.user.avatar_image}" class="avatar">
              </div>
              <div class="comment_text">
                <p class="comment_name">${comment.user.username}</p>
                <p class="comment_content">${comment.content}</p>
              </div>
            <div>`
          )
        });
      })
  }


  // ＝＝＝　いいね機能　＝＝＝
  $('.active-heart').each(function() {
    const postId = $(this).attr('id')

    // いいね判定をもとに、いいねを表示
    axios.get(`/posts/${postId}/like`)
    .then((response) => {
      const hasLiked = response.data.hasLiked
      handleHeartDisplay(hasLiked, postId)
    })
    .catch((e) => {
      console.log(e)
    })

    listenInactiveHeartEvent(postId)
    listenActiveHeartEvent(postId)
  });


  // ＝＝＝　プロフィール更新機能　＝＝＝
  // プロフィールのavatarをクリックすると画像アップローダーが開く
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

