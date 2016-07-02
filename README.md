# LHPhotoBrowser
模仿 weibo 图片浏览器 （a photoBrowser imitate weibo）

模仿微博的展示方式
支持网络图片加载
支持单点退出、 双击局部放大、 捏合放大缩小、 横屏显示
支持present以及push两种方式展现

集成LHPhotoBrowser (How to use)

LHPhotoBrowser *bc = [[LHPhotoBrowser alloc] init];

bc.imgsArray = _imgContainerArray;              //包含所有要显示略缩图ImageView的数组     (Thumbnails imageViews)

bc.imgUrlsArray = _imgUrls;                     //所有要显示图片的url                     (HD Photo url)

bc.tapImgIndex = index;                         //点击第几个图片进来的 index从0开始       (tap index, from zero)

[bc show];  //present方式（weibo方式）

[bc showWithPush:vc]; //push方式, vc为要跳转的控制器

具体见Demo

说明:如果要支持横屏 需要设置项目支持Landscape Left、Landscape Right, 如果项目不支持旋转是没有办法横屏的

Demo中 info.plist 中 App Transport Security Settings/Allow Arbitrary Loads 设置为YES,否则无法下载图片, 实际使用时根据具体情况设置

注:本框架依赖SDWebImage  (rely SDWebImage)
