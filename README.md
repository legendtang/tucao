# tucao
自制c站app

![tucao](http://upload-images.jianshu.io/upload_images/1781300-7273d79d1e47f92f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###前言
>如果说之前做的那个哔卡(已经废掉)是自娱自乐的话，那么这次这个c站的客户端就是为了以后简历可以多写点东西而写的了，acg圈里有句话叫“b站看弹幕，c站看福利，里番看琉璃”，确实c站的地位比较尴尬，属于小众网站，但正是如此，他才能看到很多别的地方看不到的东西～
当然这个客户端不是官方，依然还是我自己做的，如c站方面有任何异议，这项目便作废～
至于为什么用swift嘛～并不是因为我不会oc，其实比起oc我更不会swift，只是单纯的对swift的尝试？？？


#项目地址
Github：https://github.com/freedomstar/tucao
附带一下项目中用的弹幕框架地址(我写的框架)：https://github.com/freedomstar/MagicMasterDanmaku
框架还不完善，但基本能用（readme.md都没写orz，等框架完善会写写相关的文章）

#项目预览
###主界面

![主界面](http://upload-images.jianshu.io/upload_images/1781300-e4f8e93e2c7ea74b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



![主界面](http://upload-images.jianshu.io/upload_images/1781300-fedcacd79bb70d31.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![主界面](http://upload-images.jianshu.io/upload_images/1781300-b85c5f54bf824cfa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###子类列表
子类列表可以按条件排序，也可以将侧边栏收起
![收起](http://upload-images.jianshu.io/upload_images/1781300-46b456a61368e140.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![展开](http://upload-images.jianshu.io/upload_images/1781300-37914ff695fc8fd2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###播放界面

![播放界面](http://upload-images.jianshu.io/upload_images/1781300-9f16b4374ac21663.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![分集](http://upload-images.jianshu.io/upload_images/1781300-4bf9fef8ce1f5979.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###实际弹幕与播放效果

![实际弹幕与播放效果](http://upload-images.jianshu.io/upload_images/1781300-7eb2c2b2e5264ded.gif?imageMogr2/auto-orient/strip)

还有搜索等等界面就不展示了

#关于改进
- 已实现功能
 - 视频播放（可以调节软解质量，也可以使用硬解，基于ijkplayer）
 - 弹幕（包括发送隐藏弹幕等等，还可以调节弹幕最大数量透明度等等，高级弹幕暂不支持）
 - 搜索视频
 - 获取各分区视频，并各种分区分类显示
 - 获取评论
- 未实现功能
 - 登陆（这个实现比较难，毕竟c站没提供这方面的接口）
 - 历史观看记录
 - 离线缓存（下载视频）
- 各种改进和已知bug
 - 由于c站的接口很不全（很多都是我自己扒的 = =），所以有大量视频无法播放，需要获得更多的接口才能解决。
 - 读取视频的页面切换视频时有时会显示不正确
 - 首页的内存优化和流畅度，还是c站接口太少的问题，导致我首页设计的逻辑略微复杂，即使是arc的情况下，内存状况依然担忧，导致卡顿，而且c站的视频封面有很多gif，占用也内存大…………反正首页需要各种优化甚至直接重做orz

#关于接口
或许你们想问我的接口哪里来的，答案是[这里](http://www.tucao.tv/api.txt),这是c站官方提供的接口，当然我用到的接口不止这些，还有其他是我自己扒的接口，这个我就不公开了（你自己打开我的项目一点一点找吧！哈哈哈！） 

#第三方框架
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [Kingfisher](https://github.com/onevcat/Kingfisher)
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
- [ijkplayer](https://github.com/Bilibili/ijkplayer)
- [MagicMasterDanmaku](https://github.com/freedomstar/MagicMasterDanmaku)(我自己写的弹幕框架，虽然功能不完善，但请多多支持～)
- [MJRefresh](https://github.com/CoderMJLee/MJRefresh)

#更新
还是那句，不定期更新～

#后记说明
虽然没什么必要，但还是要说一句：该项目为开源项目，请勿用于商业用途，如果c站官方有然后异议，我将立即删除项目。


