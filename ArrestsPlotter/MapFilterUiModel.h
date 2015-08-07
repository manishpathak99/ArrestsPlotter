//
//  UserModel.h
//  comet-ios
//
//  Created by Roopesh Mittal on 5/26/15.
//  Copyright (c) 2015 MLF.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MapFilterUiModel : NSObject

@property (nonatomic, strong) NSString *labelText;
@property (nonatomic, strong) UIImage *circleImage;
@property (nonatomic, strong) UIImage *checkboxSelectedImage;
@property (nonatomic, strong) UIImage *checkboxUnselectedImage;
@property (nonatomic, assign) BOOL      isCheckBoxSelected;
@end
