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



// コメントの内容をエスケープ
const escapeHTML = (string) => {
  return string.replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#x27');
}

// コメントのHTMLをappend
const appendCommentHtml = (comment) => {
  const string = comment.content
  const text = escapeHTML(string);

  $('.comment_lists').append(
    `<div class="comment_list">
      <div class="comment_avatar">
        <img src="${comment.user.avatar_image}" class="avatar">
      </div>
      <div class="comment_text">
        <p class="comment_name">${comment.user.username}</p>
        <p class="comment_content">${text}</p>
      </div>
    <div>`
  )
}

// コメントのフォーム開閉
const showCommentForm = () => {
  $('.show-comment-form').on('click', () => {
    $('.show-comment-form').addClass('hidden')
    $('.comment-text-area').removeClass('hidden')
  })
}
const closeCommentForm = () => {
  $('.close-comment-form').on('click', () => {
    $('.show-comment-form').removeClass('hidden')
    $('.comment-text-area').addClass('hidden')
  })
}

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

// フォローボタンの表示切り替え
const followBtnSwitcher = (currentUserId, accountId) => {
  if (typeof(currentUserId && accountId) !== 'undefined') {
    axios.get(`/accounts/${accountId}/follows/${currentUserId}/`)
      .then((response) => {
        if (response.data.followStatus == true) {
          $('.btn-following').removeClass('hidden')
        } else {
          $('.btn-follow').removeClass('hidden')
        }
      })
  }
}

// フォロワー数カウントアップ機能
const followersUpCounter = () => {
  const followerCount = Number($(".follower_count").text());
  const countUp = followerCount + 1;
  $(".follower_count").text(countUp);
}
// フォロワー数カウントダウン機能
const followersDownCounter = () => {
  const followerCount = Number($(".follower_count").text());
  const countUp = followerCount - 1;
  $(".follower_count").text(countUp);
}

// フォロー機能
const listenFollowBtnEvent = (accountId) => {
  $('.btn-follow').on('click', function() {
    axios.post(`/accounts/${accountId}/follows`)
      .then((response) => {
        if (response.data.status === 'ok') {
          followersUpCounter()

          $('.btn-follow').addClass('hidden')
          $('.btn-following').removeClass('hidden')
        }
      })
      .catch((e) =>{
        console.log(e)
      })
  })
}

// フォロー解除機能
const listenFollowingBtnEvent = (accountId) => {
  $('.btn-following').on('click', function() {
    axios.post(`/accounts/${accountId}/unfollows`)
      .then((response) => {
        if (response.data.status === 'ok') {
          followersDownCounter()

          $('.btn-follow').removeClass('hidden')
          $('.btn-following').addClass('hidden')
        }
      })
      .catch((e) =>{
        console.log(e)
      })
  })
}

// アバター画像ファイルのアップロード
const avatarImageUpLoader = (file, reader) => {
  if (file.type.indexOf("image") < 0){
    alert('画像ファイルを選択してください')
  } else {
    reader.onload = () => {
      const image = reader.result;
      $('#profile-avatar-img').attr('src', image);
      $("#avatar-btn").fadeIn();
    }
    reader.readAsDataURL(file);
  }
}







document.addEventListener('DOMContentLoaded', () => {
  // ＝＝＝　コメント機能　＝＝＝
  if ($("#post-show").length) {
    const dataset = $('#post-show').data()
    const showId = dataset.showId
  
    if (typeof showId !== 'undefined') {
      axios.get(`/posts/${showId}/comments`)
        .then((response) => {
          const comments = response.data
          comments.forEach((comment) => {
            appendCommentHtml(comment)
          });
        })
    }
  
    showCommentForm()
    closeCommentForm()
  
    $('.add-comment-btn').on('click', () => {
      const content = $('#comment_content').val()
      if (!content) {
        window.alert('コメントを入力してください')
      } else {
        axios.post(`/posts/${showId}/comments`, {
          comment: {content: content}
        })
          .then((res) => {
            const comment = res.data
            appendCommentHtml(comment)
            $('#comment_content').val('')
          })
      }
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



  // ＝＝＝　フォロー機能　＝＝＝
  if ($("#profile").length) {
    const currentUserId = $('#profile').data().id
    const accountId = $('.profile').data().id
    
    // Follow・Followingの表示切り替え
    followBtnSwitcher(currentUserId, accountId)

    // Follow機能
    listenFollowBtnEvent(accountId)
    // unFollow機能
    listenFollowingBtnEvent(accountId)
  }



  // ＝＝＝　プロフィール更新機能　＝＝＝
  const uploader = $('input[type="file"]');
  
  $(uploader).on('change', (e) => {
    const file = e.target.files[0];
    const reader = new FileReader();

    avatarImageUpLoader(file, reader)
  });
});

