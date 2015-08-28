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
  
  @IBAction func click(sender: UIButton) {
    let actionSheet:HXActionSheetView = HXActionSheetView(delegate: self, cancelButtonTuple: (text:"取消",font:nil,color:nil), otherButtonTuple: (text:"其他",font:nil,color:nil), moreButtonTuple: [(text:"使用相册图片",font:nil,color:nil),(text:"使用手机拍摄",font:nil,color:nil),(text:"更换头像",font:nil,color:nil)])
    actionSheet.show()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension ViewController:HXActionSheetViewDelegate{
  func actionSheet(actionSheet: HXActionSheetView, clickedButtonAtIndex buttonIndex: Int) {
    println("clickedButtonAtIndex : \(buttonIndex)")
  }
  
  func willPresentActionSheet(actionSheet: HXActionSheetView) {
    println("willPresentActionSheet")
  }
  
  func didPresentActionSheet(actionSheet: HXActionSheetView) {
    println("didPresentActionSheet")
  }
  
  func actionSheet(actionSheet: HXActionSheetView, didDismissWithButtonIndex buttonIndex: Int) {
    println("didDismissWithButtonIndex : \(buttonIndex)")
  }
  
  func actionSheet(actionSheet: HXActionSheetView, willDismissWithButtonIndex buttonIndex: Int) {
    println("willDismissWithButtonIndex : \(buttonIndex)")
  }
  
  func actionSheetCancel(actionSheet: HXActionSheetView) {
    println("actionSheetCancel")
  }
}

