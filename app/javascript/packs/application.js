// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import $ from 'jquery'
import axios from 'axios'
import { csrfToken } from "rails-ujs";

axios.defaults.headers.common["X-CSRF-Token"] = csrfToken();

Rails.start()
Turbolinks.start()
ActiveStorage.start()



// アバターの処理
document.addEventListener('DOMContentLoaded', () => {
  $(function(){
    $('.profile-avatar-img').on('click', function(){
      $('#upFile').click();
    });
    $('#avatar-btn').on('click', function(){
      const data = new FormData();
      data.append("avatar", "avatar");
      
      axios.post('profile', data)
        .then(function (response) {
          // 送信成功時の処理
          $(this).fadeOut()
          console.log(response);
        })
        .catch(function (error) {
          // 送信失敗時の処理
          console.log(error);
        });
    });
  });

  axios.get(`/profile`)
    .then((response) => {
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
    })
});
