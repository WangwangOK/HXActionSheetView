//
//  ViewController.swift
//  HXActionSheetView
//
//  Created by Vivien on 15/8/27.
//  Copyright (c) 2015年 wangwang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  //HXActionSheetLabelTuple(text:"Swift是苹果公司在WWDC2014上发布的全新开发语言。从演示视频及随后在appstore上线的标准文档看来，语法内容混合了OC,JS,Python，语法简单，使用方便，并可与OC混合使用。作为一项苹果独立发布的支持型开发语言，已经有了数个应用演示及合作开发公司的测试，相信将在未来得到更广泛的应用。某种意义上Swift作为苹果的新商业战略，将吸引更多的开发者入门，从而增强App Store和Mac Store本来就已经实力雄厚的应用数量基础。",font:nil,color:UIColor.redColor())
  @IBAction func click(sender: UIButton) {
    let actionSheet:HXActionSheetView = HXActionSheetView(delegate: self, titleTuple: HXActionSheetLabelTuple(text:"Swift是苹果公司在WWDC2014上发布的全新开发语言。从演示视频及随后在appstore上线的标准文档看来，语法内容混合了OC,JS,Python，语法简单，使用方便，并可与OC混合使用。作为一项苹果独立发布的支持型开发语言，已经有了数个应用演示及合作开发公司的测试，相信将在未来得到更广泛的应用。某种意义上Swift作为苹果的新商业战略，将吸引更多的开发者入门，从而增强App Store和Mac Store本来就已经实力雄厚的应用数量基础。",font:nil,color:UIColor.redColor()), cancelButtonTuple: (text:"取消",font:nil,color:nil), otherButtonTuple: (text:"其他",font:nil,color:nil), moreButtonTuple: [(text:"使用相册图片",font:nil,color:nil),(text:"使用手机拍摄",font:nil,color:nil),(text:"更换头像",font:nil,color:nil),(text:"更换头像",font:nil,color:nil),(text:"更换头像",font:nil,color:nil),(text:"更换头像",font:nil,color:nil),(text:"更换头像",font:nil,color:nil),(text:"更换头像",font:nil,color:nil)])
    actionSheet.show()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension ViewController:HXActionSheetViewDelegate{
  func actionSheet(actionSheet: HXActionSheetView, clickedButtonAtIndex buttonIndex: Int) {
    print("clickedButtonAtIndex : \(buttonIndex)")
  }
  
  func willPresentActionSheet(actionSheet: HXActionSheetView) {
    print("willPresentActionSheet")
  }
  
  func didPresentActionSheet(actionSheet: HXActionSheetView) {
    print("didPresentActionSheet")
  }
  
  func actionSheet(actionSheet: HXActionSheetView, didDismissWithButtonIndex buttonIndex: Int) {
    print("didDismissWithButtonIndex : \(buttonIndex)")
  }
  
  func actionSheet(actionSheet: HXActionSheetView, willDismissWithButtonIndex buttonIndex: Int) {
    print("willDismissWithButtonIndex : \(buttonIndex)")
  }
  
  func actionSheetCancel(actionSheet: HXActionSheetView) {
    print("actionSheetCancel")
  }
}

