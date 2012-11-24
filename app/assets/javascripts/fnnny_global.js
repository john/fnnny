FB.init({
  appId:'295556897221526', cookie:true, status:true, xfbml:true
});

var Fnnny = {
  
  // fb share code (https://developers.facebook.com/docs/reference/javascript/FB.ui/)
  pushToFB: function(lnk, cap) {
    FB.ui({ method: 'feed', caption: cap, link: lnk});
  },
  
  follow: function(follower, followee) {
  },
  
  shareToFB: function(id) {
  }
  
}
