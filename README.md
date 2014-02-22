#### 要求

* rails
* rvm（ruby版本及gem管理工具）
* backbone（前端mvc框架）
* coffeescript（javascript变体，前端的javascrip都是coffeescript文件）
* haml（后台rails用到的页面模板，没有用默认的erb）
* bootstrap（css框架）
* highchart（图表工具，timeline的绘制）
* captoinfo（部署代码工具）
* rubymine（开发工具，建议采用以提升开发效率）
* passenger（托管rails程序，包括两部分：nginx模块和gem。详见后面的运维部分）
* private_pub （ruby gem，用来做公告的推送）
* resque（ruby gem，用来做和redis配合，做异步队列，如用户属性的增删改查）

#### 概览

整个前端分为五个部分：

* `/users/sign_in` - 用户登陆注册（用devise搭建）
* `/projects/age` - 查看一个项目的报告
* `/` - 查看该用户所有项目的的简要报告
* `/manage` - 用户管理project/user(创建项目/添加项目成员...)
* `/template/projects` - xa后台管理系统：管理系统默认报告，发布公告...

注意：服务器端基本只提供rest/json形式的api，所有的页面文件（除了初始的layout）都是在浏览器端渲染的（用的js模板），

#### models

详见`app/models`底下的模型文件，注意理清楚里面的`one to one` `one to many` `many to many`等模型之间的关系．项目相关的model会一次性的全部加载到浏览器端（见下面）．


#### 访问 a.xingcloud.com/projects/age

请求首先到达`ProjectsController#show`, render的view是`views/project/show.haml`, 这个view被加载到客户端之后里面的js会被
执行：

```javascript
:javascript
  window.XAUSER = "#{session[:cas_user]}";
  window.XA.init({app: "xaa", uid: XAUSER});
  window.ROOT = "#{'/projects/'+params[:id]}";
  Instances.Models.project = new Analytics.Models.Project(#{@project.js_attributes.to_json});  
  Instances.Models.setting = new Analytics.Models.Setting(#{@project.setting.present? ?   @project.setting.attributes.to_json : {}});
  Instances.Models.project.loading(); // 向服务器端请求：报告定义/用户属性/用户群...

```

拿到所有必要的数据之后，开始渲染页面。`backbone/models/project.coffee` :

``` coffeescript

  load_finished: (project) ->
    Instances.Collections.translations.attach_translation()
    Instances.Models.user.set_project_user() #todo:必须在render所有view之前执行,因为要做权限判断(其实可以在服务器端完成)
    
    # 绘制header
    new Analytics.Views.Projects.HeaderView({project: Instances.Models.project.attributes}).render();
    
    # 绘制左侧报告导航栏，绘制指定的报告（/projects/age/reports/165）,url没有指定报告时redirect到dashboard,见下面
    new Analytics.Views.Projects.ShowView({model: project}).render()
    
    # 初始化所有router
    Instances.Routers = {
      report_categories_router: new Analytics.Routers.ReportCategoriesRouter(),
      reports_router: new Analytics.Routers.ReportsRouter(),
      segments_router: new Analytics.Routers.SegmentsRouter(),
      widgets_router: new Analytics.Routers.WidgetsRouter(),
      projects_router: new Analytics.Routers.ProjectsRouter()
    }
...
    
    # redirect到dashboard
    if need_redirect
      Analytics.Utils.redirect("dashboard")
      

```

点击左侧导航栏目一个报告之后，会触发路由如`/reports/165`，接着`ReportsRouter#show`被执行，开始渲染一个报告的页面，
参考`Analytics.Views.Reports.ShowView`， report发起report_tab的渲染，report_tab接着发起timelines/kpis/dimensions
的渲染。

必要的页面渲染完之后，就开始请求并且填充报告数据，参考`Analytics.Views.ReportTabs.ShowView#fetch_data`。

#### 控制面板逻辑

整个页面的交互基本都是由控制面板驱动的，`Analytics.Views.ReportTabs.PanelView`控制整个面板的渲染（由
`Analytics.Views.ReportTabs.ShowView`触发）：日期相关参数的选择由`Analytics.Views.ReportTabs.ShowRangePickerView`负责,
dimension的选择由`Analytics.Views.Dimensions.TagsView`负责,用户群的选择由`Analytics.Views.Segments.TagsView`负责.用户
群的选择是全局的，所以直接根据用户的选择在`Instances.Collections.segments`里做标记，dimension和日期则是每个report_tab
都不一样的，所以相关操作基本都是对`Instances.Models.project.active_tab`的修改(参考`Analytics.Views.Reports.ShowView`).

修改完后，接着是分析数据的重新请求及页面刷新，以dimension选择为例:点击一个dimension tag会修改report_tab的相关字段，接着
`Analytics.Views.Charts.DimensionsView`会被redraw，接着`Analytics.Collections.DimensionCharts`重新向后台请求数据(根据修改后的report_tab)，如果点击的是具体的一个dimension value，则整个`Analytics.Views.ReportTabs.ShowView`都会被重画（因为这
相当于增加了个用户群，timeline和dimension都会受影响）．

#### 访问 a.xingcloud.com

这个链接会显示用户所在的所有项目的一个简要数据报告．

`ApplicationController#home` -> project/index.haml -> `Analytics.Collections.Projects` -> `ApplicationController#project_details`,接着`Analytics.Views.Projects.IndexView`调用`Analytics.Views.Projects.IndexItemView`，后者调用`Analytics.Collections.ProjectSummaryCharts`获取每个项目的简要报告．


#### 访问 a.xingcloud.com/manage/projects

管理用户所在的项目（增删改查项目成员）．主要涉及两个controller:`manage/projects_controller.rb`和`user_projects_controller.rb` . 

#### 代码部署

采用的部署工具是`captoinfo`

```shell
cd xa-analytics
cap -T #查看可用的部署命令

cap deploy #一般用这个
cap deploy:migration #有数据库变更时用这个
```

有时候需要进行一些数据迁移，如为metrics添加scales字段，将已有的scale和scale_startdate字段拼接起来赋给它．新进入服务器端的rails控制台．

```shell
cd /home/app/apps/analytic2.0/current
export RAILS_ENV=production
bundle exec rails console

```

接着在控制台里执行相关指令，这个例子就是:

```ruby
Metric.all.each do |metric|
  if metric.scale_startdate.nil?
    metric.scale_startdate="1970-01-01"
  end
  metric.scales=metric.scale_startdate+":"+metric.scale.to_s
  metric.save
end

```

当然也可以写一个rake，在执行cap deploy后执行，直接在客户端远程完成操作．首先添加`lib/tasks/migrate_scale.rb`，接着：

```　shell
cap deploy
cap sake:invoke task=migrate_scale
```

#### 更换git仓库地址

1.更新`config/deploy.rb`文件；2.删掉服务器上的`/home/app/apps/analytic2.0/shared/cached-copy`目录（默认从缓存拉新代码部署，这里的地址还是旧地址，删掉，captoinfo会根据deploy.rb的新地址重新初始化代码）．


#### 本地调试

记得启动redis服务，user_attributes的和后台的同步操作是异步的，详见`user_attributes_controller.rb`

#### 用户信息

现在的用户信息都是每次请求`ProjectsController#show`时先调用`fetch_project_members`向p请求该项目的成员，把没有同步的成员加到users表里去（并创建相应的project_users关系）。

a也有自己的用户登录注册及用户/项目管理系统，登录注册部分采用开源的`devise`模块(`users/sign_in`)，用户/项目管理相关代码在`manage/`底下。启用之前需要先从p同步数据（user/project）。

#### 基本运维

服务器挂了，p连不上了，找运维。其他就是代码如何部署到线上（搜索`captoinfo`的使用，参考代码部署部分）。

    
重启：

    cd  /home/app/apps/analytic2.0/current
    touch tmp/restart.txt #passenger会监控这个文件的最后修改时间，重新加载整个rails
    
passenger:

    /home/app/nginx #nginx安装目录
    /home/app/nginx/conf/conf.d/passenger.conf #passenger模块的配置文件 
