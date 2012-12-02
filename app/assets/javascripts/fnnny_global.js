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
  
  
  // pullDownAction: function() {
  //     $.ajax({
  //       url: '/items/' + last_item_id + '/since',
  //       dataType: 'script'
  //     });
  //     
  //     myScroll.refresh();    // Remember to refresh when contents are loaded (ie: on ajax completion)
  //   },
  //   
  //   pullUpAction:  function() {
  //     $.ajax({
  //       url: '/items/' + last_item_id + '/since',
  //       dataType: 'script'
  //     });
  // 
  //     myScroll.refresh();    // Remember to refresh when contents are loaded (ie: on ajax completion)
  //   },
  //   
  //   loaded: function() {
  //     pullDownEl = document.getElementById('pullDown');
  //     pullDownOffset = pullDownEl.offsetHeight;
  //     pullUpEl = document.getElementById('pullUp');  
  //     pullUpOffset = pullUpEl.offsetHeight;
  //   
  //     myScroll = new iScroll('wrapper', {
  //       useTransition: true,
  //       topOffset: pullDownOffset,
  //       onRefresh: function () {
  //         if (pullDownEl.className.match('loading')) {
  //           pullDownEl.className = '';
  //           pullDownEl.querySelector('.pullDownLabel').innerHTML = 'Pull down to refresh...';
  //         } else if (pullUpEl.className.match('loading')) {
  //           pullUpEl.className = '';
  //           pullUpEl.querySelector('.pullUpLabel').innerHTML = 'Pull up to load more...';
  //         }
  //       },
  //       onScrollMove: function () {
  //         if (this.y > 5 && !pullDownEl.className.match('flip')) {
  //           pullDownEl.className = 'flip';
  //           pullDownEl.querySelector('.pullDownLabel').innerHTML = 'Release to refresh...';
  //           this.minScrollY = 0;
  //         } else if (this.y < 5 && pullDownEl.className.match('flip')) {
  //           pullDownEl.className = '';
  //           pullDownEl.querySelector('.pullDownLabel').innerHTML = 'Pull down to refresh...';
  //           this.minScrollY = -pullDownOffset;
  //         } else if (this.y < (this.maxScrollY - 5) && !pullUpEl.className.match('flip')) {
  //           pullUpEl.className = 'flip';
  //           pullUpEl.querySelector('.pullUpLabel').innerHTML = 'Release to refresh...';
  //           this.maxScrollY = this.maxScrollY;
  //         } else if (this.y > (this.maxScrollY + 5) && pullUpEl.className.match('flip')) {
  //           pullUpEl.className = '';
  //           pullUpEl.querySelector('.pullUpLabel').innerHTML = 'Pull up to load more...';
  //           this.maxScrollY = pullUpOffset;
  //         }
  //       },
  //       onScrollEnd: function () {
  //         if (pullDownEl.className.match('flip')) {
  //           pullDownEl.className = 'loading';
  //           pullDownEl.querySelector('.pullDownLabel').innerHTML = 'Loading...';
  //           Fnnny.pullDownAction();
  //         } else if (pullUpEl.className.match('flip')) {
  //           pullUpEl.className = 'loading';
  //           pullUpEl.querySelector('.pullUpLabel').innerHTML = 'Loading...';
  //           Fnnny.pullUpAction();
  //         }
  //       }
  //     });
  //   
  //     setTimeout(function () { document.getElementById('wrapper').style.left = '0'; }, 800);
  //   } // end loaded
  
}
