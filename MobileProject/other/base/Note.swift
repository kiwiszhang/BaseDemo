//
//  Note.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/7.
//  Copyright © 2019 于晓杰. All rights reserved.
//

/*
 [
   {
     "attributes": {
       "description": {
         "standard": "unlimited access to all alarm features"
       },
       "icuLocale": "zh_US@currency=USD",
       "isFamilyShareable": 0,
       "isMerchandisedEnabled": 0,
       "isMerchandisedVisibleByDefault": 0,
       "isSubscription": 1,
       "kind": "Auto-Renewable Subscription",
       "name": "dont touch my phone annual",
       "offerName": "com.tayue.donttouchphone69.9",
       "offers": [
         {
           "assets": [],
           "buyParams": "productType=A&price=69990&salableAdamId=6737683999&pricingParameters=STDQ&pg=default&offerName=com.tayue.donttouchphone69.9&appAdamId=6737682904",
           "currencyCode": "USD",
           "price": 69.99,
           "priceFormatted": "US$69.99",
           "recurringSubscriptionPeriod": "P1Y",
           "type": "buy"
         }
       ],
       "releaseDate": "2009-06-17",
       "subscriptionFamilyId": "21573804",
       "subscriptionFamilyName": "Don't Touch My Phone",
       "subscriptionFamilyRank": 3,
       "url": "https://sandbox.itunes.apple.com/us/app/dont-touch-my-phone-annual/id6737682904?l=zh"
     },
     "href": "/v1/catalog/us/in-apps/6737683999?l=zh-Hans-CN",
     "id": "6737683999",
     "type": "in-apps"
   },
   {
     "attributes": {
       "description": {
         "standard": "unlimited access to all alarm features"
       },
       "icuLocale": "zh_US@currency=USD",
       "isFamilyShareable": 0,
       "isMerchandisedEnabled": 0,
       "isMerchandisedVisibleByDefault": 0,
       "isSubscription": 1,
       "kind": "Auto-Renewable Subscription",
       "name": "dont touch my phone weekly",
       "offerName": "com.tayue.donttouchphone9.9",
       "offers": [
         {
           "assets": [],
           "buyParams": "productType=A&price=9990&salableAdamId=6737683203&pricingParameters=STDQ&pg=default&offerName=com.tayue.donttouchphone9.9&appAdamId=6737682904",
           "currencyCode": "USD",
           "discounts": [
             {
               "modeType": "FreeTrial",
               "numOfPeriods": 1,
               "price": 0,
               "priceFormatted": "US$0.00",
               "recurringSubscriptionPeriod": "P3D",
               "type": "IntroOffer"
             }
           ],
           "price": 9.99,
           "priceFormatted": "US$9.99",
           "recurringSubscriptionPeriod": "P7D",
           "type": "buy"
         }
       ],
       "releaseDate": "2009-06-17",
       "subscriptionFamilyId": "21573804",
       "subscriptionFamilyName": "Don't Touch My Phone",
       "subscriptionFamilyRank": 1,
       "url": "https://sandbox.itunes.apple.com/us/app/dont-touch-my-phone-weekly/id6737682904?l=zh"
     },
     "href": "/v1/catalog/us/in-apps/6737683203?l=zh-Hans-CN",
     "id": "6737683203",
     "type": "in-apps"
   },
   {
     "attributes": {
       "description": {
         "standard": "unlimited access to all alarm features"
       },
       "icuLocale": "zh_US@currency=USD",
       "isFamilyShareable": 0,
       "isMerchandisedEnabled": 0,
       "isMerchandisedVisibleByDefault": 0,
       "isSubscription": 1,
       "kind": "Auto-Renewable Subscription",
       "name": "dont touch my phone monthly",
       "offerName": "com.tayue.donttouchphone29.9",
       "offers": [
         {
           "assets": [],
           "buyParams": "productType=A&price=29990&salableAdamId=6737683749&pricingParameters=STDQ&pg=default&offerName=com.tayue.donttouchphone29.9&appAdamId=6737682904",
           "currencyCode": "USD",
           "price": 29.99,
           "priceFormatted": "US$29.99",
           "recurringSubscriptionPeriod": "P1M",
           "type": "buy"
         }
       ],
       "releaseDate": "2009-06-17",
       "subscriptionFamilyId": "21573804",
       "subscriptionFamilyName": "Don't Touch My Phone",
       "subscriptionFamilyRank": 2,
       "url": "https://sandbox.itunes.apple.com/us/app/dont-touch-my-phone-monthly/id6737682904?l=zh"
     },
     "href": "/v1/catalog/us/in-apps/6737683749?l=zh-Hans-CN",
     "id": "6737683749",
     "type": "in-apps"
   }
 ]
 */
/*
attributes.name
attributes.description.standard
priceFormatted
recurringSubscriptionPeriod
id
attributes.offerName

modeType    "FreeTrial"    促销类型：免费试用
recurringSubscriptionPeriod    "P3D"    试用时长：3天
price    0    试用价格：0元
*/
/*
 商品详情
 attributes.name    "dont touch my phone weekly"    产品显示名称：用户看到的订阅套餐名称（需本地化翻译）
 attributes.description.standard    "unlimited access..."    功能描述：展示给用户的订阅权益说明
 attributes.offers[0].priceFormatted    "US$9.99"    格式化价格：直接显示在UI上的价格字符串（含货币符号）
 attributes.offers[0].recurringSubscriptionPeriod    "P7D"    订阅周期：<br>• P7D=7天<br>• P1M=1个月<br>• P1Y=1年
 
 id    "6737683203"    产品唯一ID：用于向App Store发起购买请求
 attributes.offerName    "com.tayue.donttouchphone9.9"    产品标识符：与App Store Connect后台配置的ID一致
 attributes.offers[0].buyParams    "productType=A&price=9990..."    购买参数：需原样传给App Store支付系统
 attributes.offers[0].currencyCode    "USD"    货币类型：用于货币换算和本地化显示
 
 attributes.kind    "Auto-Renewable Subscription"    订阅类型：<br>• 自动续订<br>• 非续订订阅<br>• 消耗型产品
 attributes.isSubscription    1    是否为订阅：1=是，0=否
 attributes.subscriptionFamilyId    "21573804"    订阅组ID：同组产品可切换（如月付切年付）
 attributes.subscriptionFamilyRank    1    组内优先级：数字越小显示顺序越靠前
 
 modeType    "FreeTrial"    促销类型：免费试用
 recurringSubscriptionPeriod    "P3D"    试用时长：3天
 price    0    试用价格：0元
 
 attributes.icuLocale    "zh_US@currency=USD"    本地化配置：中文界面+美元结算
 attributes.isFamilyShareable    0    家庭共享：0=不支持共享
 attributes.url    "https://sandbox..."    测试环境链接：仅沙盒环境有效
 href    "/v1/catalog/..."    API资源路径：用于请求更多详情
 */
