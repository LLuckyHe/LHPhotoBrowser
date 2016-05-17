# LHPhotoBrowser
模仿 weibo 图片浏览器 （a photoBrowser imitate weibo）

模仿微博的展示方式
支持网络图片加载
支持单点退出、 双击局部放大、 捏合放大缩小、 横屏显示

集成LHPhotoBrowser (How to use)
LHPhotoBrowser *bc = [[LHPhotoBrowser alloc] init];
bc.imgsArray = _imgContainerArray;              //包含所有要显示略缩图ImageView的数组     (Thumbnails imageViews)
bc.imgUrlsArray = _imgUrls;                     //所有要显示图片的url                     (HD Photo url)
bc.tapImgIndex = index;                         //点击第几个图片进来的 index从0开始       (tap index, from zero)
[bc show];                                      

具体见Demo

注:本框架依赖SDWebImage  (rely SDWebImage)
