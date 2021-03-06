Template.profileMain.onRendered ->
  @$('.progress-container').hide()
  @$('.qr-code').qrcode
    text: userById(@data.user)
  if isMe(@data.user)
    initUploader @

Template.profileMain.helpers
  title: -> userPrefix(@user, true) + '个人中心'
  nickname: -> @nickname or (isMe(@user) and '添加昵称' or '')
  location: -> @location or (isMe(@user) and '添加地址' or '')
  nicknameEditorUrl: -> isMe(@user) and "/profile?type=nickname&user=#{@user}" or ''
  locationEditorUrl: -> isMe(@user) and "/profile?type=location&user=#{@user}" or ''
  lines: -> [
    getLine.call(@, 'qq', 'QQ')
    getLine.call(@, 'wechat', '微信')
    getLine.call(@, 'mobile', '手机号')
    getLine.call(@, 'signature', '签名')
  ]
  myFavoriteUsersPath: -> "/user/list?favoritesby=#{myId()}"
  certificatePath: -> "/certificate/list?user=#{@user}"

Template.profileMain.events

  'click .avatar': ->
    key = avatarKey(@user)
    if key and (not isMe(@user))
      showBigAvatar(key)

  'click [data-action=logout]': ->
    Meteor.logout()
    Router.go '/'

Template.ionNavBar.events

  'click [data-action=back-to-main]': ->
    $("[data-action=back-to-main]").data('nav-direction', 'back')
    back()

  'click [data-action=share]': ->
    if Meteor.isCordova
      window.plugins.socialsharing.share '', userPrefix(@user, true) + '潜水吧个人中心', avatarUrl @user, currentUrl()
    else
      alert '这是手机上才有的功能。'



newAvatarKey = -> 'avatar-' + myId() + '-' + new Date().getTime()

initUploader = (self)->
  Meteor.call 'uptoken', (error, result)->
    if error
      console.log error
    else
      uploader = Qiniu.uploader
        runtimes: 'html5,flash,html4'               #上传模式,依次退化
        browse_button: self.find '.avatar'          #上传选择的点选按钮，**必需**
        uptoken : result                            #若未指定uptoken_url,则必须指定 uptoken ,uptoken由其他程序生成
        domain: qiniuConfig.DOMAIN                  #bucket 域名，下载资源时用到，**必需**
        max_file_size: '3mb'                        #最大文件体积限制
        max_retries: 3                              #上传失败最大重试次数
        dragdrop: false                             #开启可拖曳上传
        chunk_size: '4mb'                           #分块上传时，每片的体积
        auto_start: true                            #选择文件后自动上传，若关闭需要自己绑定事件触发上传
        multi_selection: false
        # Specify what files to browse for
        filters: [{
          title: "Image files"
          extensions: "jpg,gif,png,jpeg"
        }]

        init:
          'Key': (up, file)->
            file.key = newAvatarKey self, file
            return file.key

          'BeforeUpload': (up, file)->
            resetImageSrc self, file.key
            showUploadProgress self, file.key, 0

          'FileUploaded': (up, file, info)->
            info = JSON.parse info
            Profiles.update {_id: Meteor.user().profileId}, {$set: {avatar: info.key}}
            hideUploadProgress self, file.key
            resetImageSrc self, file.key

          'UploadProgress': (up, file)->
            showUploadProgress self, file.key, file.percent

          'Error': (up, err, errTip)->
            console.log err, errTip

getLine = (type, label)->
  label: label
  data: @[type]
  href: isMe(@user) and "/profile?type=#{type}&user=#{@user}" or ''
  icon: isMe(@user) and "ios-arrow-right" or ''

showUploadProgress = (self, key, percent)->
  progressContainer = self.$(".progress-container")
  progressLabel = self.$(".progress")
  progressContainer.show()
  progressLabel.html(percent + '%')

hideUploadProgress = (self, key)->
  progressContainer = self.$(".progress-container")
  progressLabel = self.$(".progress")
  progressContainer.hide()
  progressLabel.html('0%')

resetImageSrc = (self, key)->
  image = self.$(".avatar .image")
  image.attr 'src', imageUrl(key, {mode: 1, w: 96, h: 96, q: 80})

showBigAvatar = (key)->
  qiniuImageInfo key, {}, (info)-> showPhotoSwipe($('.pswp')[0], 1, [info])
