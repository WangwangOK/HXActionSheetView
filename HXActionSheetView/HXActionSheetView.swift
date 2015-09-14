//
//  HXActionSheetView.swift
//  HXActionSheetView
//
//  Created by Vivien on 15/8/27.
//  Copyright (c) 2015年 wangwang. All rights reserved.
//

import Foundation
import UIKit

let kHXActionSheetLabelFontSize:CGFloat = 14

let kFixedHeight:CGFloat = 50

@objc protocol HXActionSheetViewDelegate{
  // Called when a button is clicked. The view will be automatically dismissed after this call returns
  optional func actionSheet(actionSheet: HXActionSheetView, clickedButtonAtIndex buttonIndex: Int)
  // Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
  // If not defined in the delegate, we simulate a click in the cancel button
  optional func actionSheetCancel(actionSheet: HXActionSheetView)
  
  optional func willPresentActionSheet(actionSheet: HXActionSheetView) // before animation and showing view
  
  optional func didPresentActionSheet(actionSheet: HXActionSheetView) // after animation
  
  optional func actionSheet(actionSheet: HXActionSheetView, willDismissWithButtonIndex buttonIndex: Int) // before animation and hiding view
  
  optional func actionSheet(actionSheet: HXActionSheetView, didDismissWithButtonIndex buttonIndex: Int) // after animation
}

typealias HXActionSheetLabelTuple = (text:String,font:UIFont?,color:UIColor?)

class HXActionSheetView:UIView,UIActionSheetDelegate {
  
  weak var delegate:HXActionSheetViewDelegate?
  
  var tapGesture:UITapGestureRecognizer?
  
  private let kScreenWidth                             = {
    return UIScreen.mainScreen().bounds.size.width
    }()
  
  private let kScreenHeight                            = {
    return UIScreen.mainScreen().bounds.size.height
    }()
  
  private let kDistanceCancleToTable:CGFloat           = {
    return 5
    }()
  
  private let dequeueReusableCellWithIdentifier:String = {
    return "HXActionSheetIdentifier"
    }()
  
  private let tableView:UITableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
  
  private var titletuple:HXActionSheetLabelTuple?
  
  private let titleViewwidth:CGFloat = CGRectGetWidth(UIScreen.mainScreen().bounds) - 20
  
  private var titleViewheight:CGFloat {
    
    if self.titletuple == nil {
      return 0
    }
    let text = self.titletuple!.text as NSString
    let font = titletuple!.font == nil ? UIFont.systemFontOfSize(kHXActionSheetLabelFontSize) : titletuple!.font!
    let height = text.boundingRectWithSize(CGSizeMake(titleViewwidth, 10000), options: NSStringDrawingOptions.TruncatesLastVisibleLine | NSStringDrawingOptions.UsesLineFragmentOrigin | NSStringDrawingOptions.UsesFontLeading, attributes: [NSFontAttributeName:font], context: nil).height
    return height + 10 >= kFixedHeight ? height + 10 : kFixedHeight
  }
  
  private var cancleButton:UIButton?
  
  private let actionWindow:UIWindow = UIWindow()
  
  private var dataSource:Array<HXActionSheetLabelTuple> = []
  
  convenience init(delegate: HXActionSheetViewDelegate?, titleTuple:HXActionSheetLabelTuple?,cancelButtonTuple: HXActionSheetLabelTuple?, otherButtonTuple: HXActionSheetLabelTuple, moreButtonTuple: [HXActionSheetLabelTuple]){
    self.init()
    self.delegate   = delegate == nil ? nil : delegate
    self.titletuple = titleTuple == nil ? nil : titleTuple!
    dataSource.append(otherButtonTuple)
    for tuple in moreButtonTuple{
      dataSource.append(tuple)
    }
    setupWith(self.tableView)
    setupWith(cancelButtonTuple, tableView: self.tableView)
    self.frame           = cancelButtonTuple == nil ? CGRectMake(0, kScreenHeight, kScreenWidth, self.tableView.frame.size.height) : CGRectMake(0, kScreenHeight, kScreenWidth, self.tableView.frame.size.height + kFixedHeight + kDistanceCancleToTable)
    self.backgroundColor = UIColor(red: 227.0 / 255.0, green: 227.0 / 255.0, blue: 229.0 / 255.0, alpha: 1.0)
  }
  
  private func setupWith(tableView:UITableView){
    tableView.delegate                     = self
    tableView.dataSource                   = self
    tableView.tableHeaderView              = UIView(frame: CGRectMake(0, 0, 0, CGFloat.min))
    tableView.backgroundColor              = UIColor.whiteColor()
    tableView.rowHeight                    = kFixedHeight
    tableView.showsVerticalScrollIndicator = false
    tableView.separatorInset               = UIEdgeInsetsMake(0, 0, 0, 0)
    let height                             = CGFloat(self.dataSource.count) * kFixedHeight + titleViewheight < kScreenHeight / 2 ? CGFloat(self.dataSource.count) * kFixedHeight + titleViewheight : kScreenHeight / 2
    let iscanScroll                        = CGFloat(self.dataSource.count) * kFixedHeight + titleViewheight <= kScreenHeight / 2 ? false : true
    tableView.scrollEnabled                = iscanScroll
    tableView.frame                        = CGRectMake(0, 0, kScreenWidth, height)
    self.addSubview(tableView)
  }
  
  private func setupWith(cancelButtonTuple:HXActionSheetLabelTuple?,tableView:UITableView){
    if cancelButtonTuple == nil {
      return
    }
    self.cancleButton                        = UIButton()
    self.cancleButton!.backgroundColor       = UIColor.whiteColor()
    self.cancleButton!.frame                 = CGRectMake(0, tableView.frame.size.height + kDistanceCancleToTable, kScreenWidth, kFixedHeight)
    self.cancleButton!.setTitle(cancelButtonTuple!.text, forState: UIControlState.Normal)
    let textColor                            = cancelButtonTuple!.color == nil ? UIColor.blackColor() : cancelButtonTuple!.color
    self.cancleButton!.setTitleColor(textColor, forState: UIControlState.Normal)
    self.cancleButton!.titleLabel!.font      = cancelButtonTuple!.font == nil ? UIFont.systemFontOfSize(kHXActionSheetLabelFontSize) : cancelButtonTuple!.font
    self.cancleButton!.titleLabel!.textColor = UIColor.darkGrayColor()
    self.cancleButton!.addTarget(self, action: "clickButton:", forControlEvents: UIControlEvents.TouchUpInside)
    self.addSubview(self.cancleButton!)
  }
  
  private func setupWith(window:UIWindow){
    window.frame                          = CGRectMake(0, 0, kScreenWidth, kScreenHeight)
    window.addSubview(self)
    window.backgroundColor                = UIColor.blackColor().colorWithAlphaComponent(0.3)
    window.windowLevel                    = UIWindowLevelAlert
    window.makeKeyAndVisible()
  }
  
  private func dismiss(buttonIndex:Int?){
    
    if buttonIndex != nil {
      self.delegate?.actionSheet?(self, willDismissWithButtonIndex:buttonIndex!)
    }
    UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.transform = CGAffineTransformMakeTranslation(0, 0)
      }) { (result:Bool) -> Void in
        if result == false {
          return
        }
        for subView in self.actionWindow.subviews{
          if let view = subView as? UIView{
            view.removeFromSuperview()
          }
        }
        if buttonIndex != nil{
          self.delegate?.actionSheet?(self, didDismissWithButtonIndex: buttonIndex!)
        }
        self.delegate                 = nil
        self.tableView.delegate       = nil
        self.tableView.dataSource     = nil
        self.tableView.removeFromSuperview()
        self.actionWindow.removeGestureRecognizer(self.tapGesture!)
        self.tapGesture               = nil
        self.actionWindow.windowLevel = UIWindowLevelNormal
        self.actionWindow.hidden      = true
    }
  }
  
  func show(){
    setupWith(actionWindow)
    self.delegate?.willPresentActionSheet?(self)
    UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height)
      self.delegate?.didPresentActionSheet?(self)
      }) { (Bool) -> Void in
        self.tapGesture           = UITapGestureRecognizer(target: self, action: "tapWindow:")
        self.tapGesture!.delegate = self
        self.actionWindow.addGestureRecognizer(self.tapGesture!)
    }
  }
  
  func clickButton(sender:UIButton){
    dismiss(0)
    self.delegate?.actionSheet?(self, clickedButtonAtIndex: 0)
    self.delegate?.actionSheetCancel?(self)
  }
  
  func tapWindow(tapGesture:UITapGestureRecognizer){
    dismiss(nil)
  }
  
  override func layoutSubviews() {
    self.tableView.separatorInset = UIEdgeInsetsZero
    if  ((UIDevice.currentDevice().systemVersion) as NSString).floatValue >= 8.0 {
      self.tableView.layoutMargins = UIEdgeInsetsZero
    }
  }
}

extension HXActionSheetView:UITableViewDelegate,UITableViewDataSource{
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier(dequeueReusableCellWithIdentifier) as? HXActionSheetViewCell
    if cell == nil{
      cell = HXActionSheetViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: dequeueReusableCellWithIdentifier)
    }
    cell!.selectionStyle = UITableViewCellSelectionStyle.None
    cell!.setup(self.dataSource.reverse()[indexPath.row])
    return cell!
  }
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.separatorInset = UIEdgeInsetsZero
    if  ((UIDevice.currentDevice().systemVersion) as NSString).floatValue >= 8.0 {
      cell.layoutMargins = UIEdgeInsetsZero
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var startIndex = self.cancleButton == nil ? 0 : 1
    self.delegate?.actionSheet?(self, clickedButtonAtIndex: startIndex + indexPath.row)
    dismiss(startIndex + indexPath.row)
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

    return titleViewheight
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if self.titletuple == nil {
      return nil
    }
    let titleView = UIView()
    titleView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.01)
    let titlelabel            = UILabel()
    func addtitlelabelWithHeader(){
      titlelabel.text          = titletuple!.text
      titlelabel.numberOfLines = 0
      titlelabel.textAlignment = NSTextAlignment.Center
      titlelabel.font          = titletuple!.font == nil ? UIFont.systemFontOfSize(kHXActionSheetLabelFontSize) : titletuple!.font!
      titlelabel.textColor     = titletuple!.color == nil ? UIColor.blackColor() : titletuple!.color!
      titlelabel.center        = CGPointMake(CGRectGetWidth(UIScreen.mainScreen().bounds) / 2, titleViewheight / 2)
      titlelabel.bounds        = CGRectMake(0, 0, titleViewwidth, titleViewheight - 10)
    }
    addtitlelabelWithHeader()
    let lineview = UIView(frame: CGRectMake(0, titleViewheight - 1, CGRectGetWidth(UIScreen.mainScreen().bounds), 0.1))
    lineview.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
    titleView.addSubview(lineview)
    titleView.addSubview(titlelabel)
    return titleView
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return CGFloat.min
  }
}


extension HXActionSheetView:UIGestureRecognizerDelegate{
  override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
    var position = gestureRecognizer.locationInView(self)
    return position.y < 0 ? true : false
  }
}

private class HXActionSheetViewCell: UITableViewCell {
  var descriptionLabel:UILabel = UILabel()
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    descriptionLabel.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, kFixedHeight / 2)
    descriptionLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
    descriptionLabel.textAlignment = NSTextAlignment.Center
    descriptionLabel.numberOfLines = 2
    self.contentView.addSubview(descriptionLabel)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup(tuple:HXActionSheetLabelTuple?){
    if tuple == nil {
      return
    }
    descriptionLabel.textColor = tuple!.color == nil ? UIColor.blackColor() : tuple!.color
    
    descriptionLabel.font = tuple!.font == nil ? UIFont.systemFontOfSize(kHXActionSheetLabelFontSize) : tuple!.font
    
    descriptionLabel.text = tuple!.text
  }
}

