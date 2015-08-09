//
//  FilterView.h
//  CometMapCheckBoxComponent
//
//  Created by MANISH PATHAK on 8/4/15.
//  Copyright (c) 2015 MANISH PATHAK. All rights reserved.
//

#ifndef CometMapCheckBoxComponent_FilterView_h
#define CometMapCheckBoxComponent_FilterView_h


#endif
#import <UIKit/UIKit.h>

@interface FilterView : UIView

@property (nonatomic, assign) BOOL lastCell;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) int margin;
@property (nonatomic, strong) NSArray *filters;

- (UIView*) createCheckbox:(UIImage*)uiImageSelected  uiImageUnselected:(UIImage*)uiImageUnselected isSelected:(BOOL) isSelected x:(int) x y:(int) y;
- (UIView*) createCircle:(UIImage*)circleImage  x:(int) x y:(int) y;
- (UIView*) createLabel:(NSString*)labelText  x:(int) x y:(int) y;

- (id)initCustomWithFrame:(CGRect)frame;
- (UIView*) createFilterViewWithArray:(NSArray*)filterArray;

@end
