//
//  SubscribeView.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/4/17.
//

class SubscribeView: SuperView {
    //购买部分
    private let buyBgView = UIView()
    private let buyTitleLab = UILabel().text(L10n.subTitle).hnFont(size: 20.h, weight: .medium).color(.white).centerAligned()
    private let buyDetailLab = UILabel().text(L10n.subDetail).hnFont(size: 12.h, weight: .regular).centerAligned().color(.white)
    
    private let buySubShadowView = UIView()
    private let buySubBgView = UIView().backgroundColor(.white).cornerRadius(13.h)
    private let buySubImgView = UIImageView().image(Asset.homeBuyTag.image)
    private let buySubTitleLab = UILabel().text(L10n.subBuy).hnFont(size: 12.h, weight: .medium).centerAligned()
    
    override func updateLanguageUI(){
        buyTitleLab.text(L10n.subTitle)
        buyDetailLab.text(L10n.subDetail)
        buySubTitleLab.text(L10n.subBuy)
    }
    
    override func setUpUI() {
        addSubView(buyBgView)

        buyBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        buyBgView.addGradientBackground(colors: [.colorWithHexString("050550"), .colorWithHexString("6F1599"), .colorWithHexString("A340D2")], locations: [0, 0.81, 0.96],cornerRadius: 10, direction: .bottomRightToTopLeft)
        
        buyBgView.addChildView([buyTitleLab, buyDetailLab, buySubShadowView])
        buyTitleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(12.h)
        }
        buyDetailLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(buyTitleLab.snp.bottom).offset(6.h)
        }
        buySubShadowView.snp.makeConstraints { make in
            make.top.equalTo(buyDetailLab.snp.bottom).offset(5.h)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8.h)
            make.height.equalTo(26.h)
        }
        buySubShadowView.addShadow(.black, 4.h, 0.25, 0, 4.h, buySubBgView.height/2)
        
        buySubShadowView.addSubview(buySubBgView)
        buySubBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        buySubBgView.addChildView([buySubImgView, buySubTitleLab])
        buySubImgView.snp.makeConstraints { make in
            make.size.equalTo(CGSize.init(width: 16.w, height: 13.w))
            make.left.equalToSuperview().offset(38.w)
            make.centerY.equalToSuperview()
        }
        buySubTitleLab.snp.makeConstraints { make in
            make.left.equalTo(buySubImgView.snp.right).offset(10.w)
            make.right.equalToSuperview().offset(-38.h)
            make.centerY.equalToSuperview()
        }
    }
}

