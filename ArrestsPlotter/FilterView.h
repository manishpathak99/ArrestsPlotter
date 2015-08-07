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
@property (nonatomic, assign) int x;
@property (nonatomic, assign) int y;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) int margin;


- (UIView*) createCheckbox:(UIImage*)uiImageSelected  uiImageUnselected:(UIImage*)uiImageUnselected isSelected:(BOOL) isSelected x:(int) x y:(int) y;

- (UIView*) createCircle:(UIImage*)circleImage  x:(int) x y:(int) y;

- (UIView*) createLabel:(NSString*)labelText  x:(int) x y:(int) y;

- (UIView*) createMapFilterView;
- (UIView*) createMapFilterView:(int)numberOfItems;
- (UIView*) createFilterView:(NSMutableArray*)filterArray;
- (id)initCustom;

@end
