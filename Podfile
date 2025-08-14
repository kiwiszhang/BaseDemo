platform :ios, '15.0'
use_frameworks! :linkage => :static

target 'MobileProject' do
  # UI 布局
  pod 'SnapKit', '~> 5.7.0'
  
  # 进度提示
  pod 'MBProgressHUD', '~> 0.9.2'
  
  # 本地化
  pod 'Localize-Swift', '~> 3.2'
  
  # 开发环境专用
  pod 'SwiftGen', '~> 6.6.3', :configurations => ['Debug']
  
  # 数据转模型
  pod 'HandyJSON', '5.0.0'
  
  # 图片
  pod 'Kingfisher', '~> 8.0'
  
#  pod 'WeScan'
  
  pod "TrackReport", :git => "https://github.com/OYForever/TrackReport.git"
  
  # 数据存储
  pod 'SQLite.swift', '~> 0.13.0'
  
  # 数据分析
  pod 'Firebase/Analytics'     # 可选：用于分析审核状态
  pod 'Firebase/Crashlytics'
end
