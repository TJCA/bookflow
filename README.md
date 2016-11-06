# 同济二手书漂流

这是同济大学学生会权益保障与生活福利部开发的「二手书漂流」网站的源代码，基于 Ruby on Rails 框架写就。

## Ruby 版本

推荐 2.3.0 及以上的 Ruby 版本。Rails 的版本使用 5.0.0.1。下载好代码请 `bundle install` 以安装相关的依赖包。

## 系统要求

在配置好 Ruby on Rails 环境的 GNU/Linux、macOS 系统上均能成功运行，Windows 和 FreeBSD 系统尚未测试过。

## 设置

本网站用到了「阿里大于」这个 Gem 包，用以支持验证短信的发送。在 config 目录下的 alidayu_sms.yml 配置文件中，AppID 和密钥、模版编号等都需要使用者配合自己的阿里大于账户进行配置。

config/secrets.yml 里的密钥要自己填。config/environments 里的几个配置文件需要手动填写邮箱的账号密码。

app/models/user.rb 里的密码 salt 可以用默认的，也可以自己改。

有一些 i18n 文件还没有到位，不影响正常运行。

## 数据库配置

数据库配置在 database.yml 文件里，默认用的是 Sqlite3，可以正常使用。如果想换成 PostgreSQL 或者 MySQL 等，请自行查阅 Rails 数据库配置方法，并建立对应的数据库名（默认为「bookflow」）。

数据库配置好后，执行一次迁移即可。

## 测试

测试还没做，所以是一片空白。

## 部署

如同普通的 Rails 应用，以 `rails s` 的方式即可启动，端口和 IP 绑定请自行决定，绑定本机所有 IP 请加上 `-b 0.0.0.0 ` 参数。如果想搭配 Apache 或 Nginx 等服务器运行请搜索相关教程，Rails 5 默认带的 Web Server 是 Puma。

请注意，如果在生产环境，请加上 `-e production` 参数，并确保对应环境的迁移已执行完毕。 