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
// const appendNewAvatar = (avatar) => {
//   $('.profile-avatar-img').attr('src', avatar)
// }

// document.addEventListener('DOMContentLoaded', () => {
//   $(function(){
//       $('.profile-avatar-img').on('click', function(){
//         $('#upFile').click();
//       });

//       $('.profile-avatar-img').on("load", function() {
//         axios.put(`profile`, {
//           avatar: { profile: avatar_image }
//         })
//           .then((res) => {
//             const avatar = res.data
//             appendNewAvatar(avatar)
//             console.log(res)
//           })
//       });
//     });
// });

// window.addEventListener('load', () => {
//   const uploader = document.querySelector('.form-avatar');
//   $(uploader).on('change', (e) => {
//       const file = uploader.files[0];
//       const reader = new FileReader();
//       reader.readAsDataURL(file);
//       reader.onload = () => {
//           const image = reader.result;
//           document.querySelector('.profile-avatar-img').setAttribute('src', image);
//       }
//   });
// });