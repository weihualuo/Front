
angular.module( 'myscroll', []).
    factory('Scroll', function(){

        var myScroll,
            loadCallback,
            pullDownEl, pullDownOffset,  pullDownLabel, pullDownText,
            pullUpEl, pullUpOffset,  pullUpLabel, pullUpText,
            flipText, loadText,
            IScroll = iScroll;


        function pullDownAction () {
            loadCallback(true);
        }

        function pullUpAction () {
            loadCallback(false);
        }

        function loaded() {
            pullDownEl = document.getElementById('pullDown');
            pullDownOffset = 0;
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
                        pullDownAction();	// Execute custom function (ajax call?)
                    }
                }
            });

            pullDownEl.className = 'loading';
            pullDownLabel.innerHTML = loadText;
            pullDownAction();
//            myScroll.scrollToElement(pullDownEl, 3000);
//            myScroll.scrollTo(0, -100, 200);
        }

        document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);


        return {
            init:   function(cb){
                loadCallback = cb;
                setTimeout(function(){loaded();}, 0);
            },

            refresh: function(counts){

                if (myScroll.options.topOffset === 0 ) {
                    myScroll.options.topOffset = pullDownEl.offsetHeight;
                    pullUpEl.className = 'idle';
                }
                myScroll.refresh();

            } ,

            more: function(){
                pullUpEl.className = 'loading';
                pullUpLabel.innerHTML = loadText;
                pullUpAction();
            },

            destroy: function(){
                myScroll.destroy();
                myScroll = null;
            }
        };

    }) ;
