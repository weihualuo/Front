
angular.module( 'myscroll', []).
    factory('Scroll', function(){

        var myScroll,
            loadCallback,
            pullDownEl, pullDownOffset,  pullDownLabel, pullDownText,
            pullUpEl, pullUpOffset,  pullUpLabel, pullUpText,
            flipText, loadText,
            IScroll = iScroll,
            position = {};

        function loaded(refresh) {
            pullDownEl = document.getElementById('pullDown');
            pullDownOffset = refresh ? 0: pullDownEl.offsetHeight;
            pullDownLabel = pullDownEl.querySelector('.pullDownLabel');
            pullDownText = pullDownLabel.innerHTML;
            
            pullUpEl = document.getElementById('pullUp');
            pullUpOffset = pullUpEl.offsetHeight;
            pullUpLabel =  pullUpEl.querySelector('.pullUpLabel');
            pullUpText = pullUpLabel.innerHTML;

            flipText = pullDownEl.getAttribute('data-flip');
            loadText = pullDownEl.getAttribute('data-load');

            myScroll = new IScroll('wrapper', {
                useTransition: true,
                topOffset: pullDownOffset,
                onRefresh: function () {
                    if (pullDownEl.className.match('loading')) {
                        pullDownEl.className = '';
                        pullDownLabel.innerHTML = pullDownText;
                    } else if (pullUpEl.className.match('loading')) {
                        pullUpEl.className = 'idle';
                        pullUpLabel.innerHTML = pullUpText;
                    }
                },
                onScrollMove: function () {
                    if (this.y > 5 && !pullDownEl.className.match('flip')) {
                        pullDownEl.className = 'flip';
                        pullDownLabel.innerHTML = flipText;
                        this.minScrollY = 0;
                    } else if (this.y < 5 && pullDownEl.className.match('flip')) {
                        pullDownEl.className = '';
                        pullDownLabel.innerHTML = pullDownText;
                        this.minScrollY = -pullDownOffset;
                    }
                },
                onScrollEnd: function () {
                    if (pullDownEl.className.match('flip')) {
                        pullDownEl.className = 'loading';
                        pullDownLabel.innerHTML = loadText;
                        loadCallback('refresh');
                    }
                }
            });
            if (refresh){
                pullDownEl.className = 'loading';
                pullUpEl.className = 'hide';
                pullDownLabel.innerHTML = loadText;
                loadCallback('refresh');
            }
            else if (position.y){
                myScroll.scrollTo(position.x, position.y);
            }
//            window.s = myScroll;
        }

        document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);


        return {
            init:   function(refresh, cb){
                console.log(position);
                loadCallback = cb;
                setTimeout(function(){loaded(refresh);}, 0);
            },

            refresh: function(data){

                if (myScroll.options.topOffset === 0 ) {
                    myScroll.options.topOffset = pullDownEl.offsetHeight;
                    pullUpEl.className = 'idle';
                }
                myScroll.refresh();
            } ,

            more: function(){
                pullUpEl.className = 'loading';
                pullUpLabel.innerHTML = loadText;
                loadCallback('more');
            },

            destroy: function(){
                position.y = myScroll.y;
                position.x = myScroll.x;
                myScroll.destroy();
                myScroll = null;
            }
        };

    }) ;
