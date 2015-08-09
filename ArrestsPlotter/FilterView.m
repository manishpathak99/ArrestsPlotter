//
//  FilterView.m
//  CometMapCheckBoxComponent
//
//  Created by MANISH PATHAK on 8/4/15.
//  Copyright (c) 2015 MANISH PATHAK. All rights reserved.
//

#define FONT_SIZE 8
#define MAX_LABEL_WIDTH 10
#define MAX_LABEL_HEIGHT 10
#define CHECKBOX_MARGIN_RIGHT 2
#define CIRCLE_MARGIN_RIGHT 2
#define LABEL_MARGIN_RIGHT 10

#define CHECKBOX_MARGIN_LEFT 14
#define CIRCLE_MARGIN_LEFT 0
#define LABEL_MARGIN_LEFT 0

#define CIRCLE_FRAME_WIDTH_HEIGHT 6
#define CHECKBOX_FRAME_WIDTH_HEIGHT 12
#define LABEL_FRAME_MARGIN_HEIGHT 12

#define VIEW_FRAME_MARGIN_LEFT 12
#define VIEW_FRAME_MARGIN_RIGHT 12
#define VIEW_FRAME_MARGIN_TOP 0
#define VIEW_FRAME_MARGIN_BOTTOM 80

#import <Foundation/Foundation.h>
#import "FilterView.h"
#import "MapFilterUiModel.h"

@implementation FilterView {
    int x;
    int y;
    CGFloat width;
    CGFloat height;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        margin = 0;
        //        x = 0;
        //        y = 0;
        //        width = frame.size.width;
        //        height = frame.size.height;
        
    }
    return self;
}

-(id)initCustomWithFrame:(CGRect)frame
{
    int x = frame.origin.x + VIEW_FRAME_MARGIN_LEFT;
    int y = frame.size.height - VIEW_FRAME_MARGIN_BOTTOM;
    CGFloat width = frame.size.width - VIEW_FRAME_MARGIN_LEFT - VIEW_FRAME_MARGIN_RIGHT;
    CGFloat height = 30;
    
    CGRect newFrame = CGRectMake(x, y, width, height);
    
    self = [super initWithFrame:newFrame];
    if (self) {
        [self setFrame:newFrame];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setAlpha:0.8f];
    }
    return self;
}

//-(void) drawRect: (CGRect) rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    UIColor * redColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9];
//    CGContextSetFillColorWithColor(context, redColor.CGColor);
//    CGContextFillRect(context, self.bounds);
//}


- (UIView*) createCheckbox:(UIImage*)uiImageSelected  uiImageUnselected:(UIImage*)uiImageUnselected isSelected:(BOOL) isSelected x:(int) x y:(int) y{
    
    UIButton *checkbox = [[UIButton alloc] initWithFrame:CGRectMake(x,y,CHECKBOX_FRAME_WIDTH_HEIGHT,CHECKBOX_FRAME_WIDTH_HEIGHT)];
    // is the size of the checckbox that you want
    // create 2 images sizes , one empty square and
    // another of the same square with the checkmark in it
    // Create 2 UIImages with these new images, then:
    
    [checkbox setBackgroundImage:uiImageUnselected
                        forState:UIControlStateNormal];
    [checkbox setBackgroundImage:uiImageSelected
                        forState:UIControlStateSelected];
    [checkbox setBackgroundImage:uiImageSelected
                        forState:UIControlStateHighlighted];
    checkbox.adjustsImageWhenHighlighted=YES;
    [checkbox addTarget:self action: @selector(checkboxSelectedMethod:) forControlEvents: UIControlEventTouchUpInside];
    return checkbox;
}


-(void)checkboxSelectedMethod:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    btn.selected=!btn.selected;
}

// method for creating the circle
-(UIView*) createCircle:(UIImage*)circleImage  x:(int) x y:(int) y{
    //    int imageWidth = 20, imageHeight = 20;
    CGColorRef pixelColor = [[UIColor redColor] CGColor];
    CGRect circlePoint = (CGRectMake(x, y, CIRCLE_FRAME_WIDTH_HEIGHT, CIRCLE_FRAME_WIDTH_HEIGHT));
    UIImageView *uiImageView = [[UIImageView alloc]initWithFrame:(circlePoint)];
    [uiImageView setImage:circleImage];
    return uiImageView;
}

// method for creating the label
- (UIView*) createLabel:(NSString*)labelText  x:(int) x y:(int) y{
    // knowing the label size in advance
    UILabel *labelForSize=[[UILabel alloc]init];
    [labelForSize setText:labelText];//Set text in label.
    [labelForSize setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    CGRect yourLabelSize = [labelText
                            boundingRectWithSize:labelForSize.frame.size
                            options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{ NSFontAttributeName:labelForSize.font }
                            context:nil];
    
    y= (y - yourLabelSize.size.height)/2;
    NSLog(@"x:  %d", x);
    NSLog(@"y:  %d", y);
    NSLog(@"width:  %f", yourLabelSize.size.width);
    NSLog(@"height:  %f", yourLabelSize.size.height);
    
    UILabel  *label =[[UILabel alloc] initWithFrame:CGRectMake(x,y, yourLabelSize.size.width,yourLabelSize.size.height )];
    [label setText:labelText];//Set text in label.
    [label setTextColor:[UIColor blackColor]];//Set text color in label.
    [label setTextAlignment:NSTextAlignmentNatural];//Set text alignment in label.
    [label setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];//Set line adjustment.
    [label setLineBreakMode:NSLineBreakByCharWrapping];//Set linebreaking mode..
    [label setNumberOfLines:1];//Set number of lines in label.
    [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    //    [label.layer setCornerRadius:25.0];//Set corner radius of label to change the shape.
    //        [label.layer setBorderWidth:2.0f];//Set border width of label.
    //    [label setClipsToBounds:YES];//Set its to YES for Corner radius to work.
    //    [label.layer setBorderColor:[UIColor blackColor].CGColor];//Set Border color.
    
    
    //adjust the label the the new height.
    //       CGRect newFrame = label.frame;
    //    newFrame.size.height = expectedLabelSize.height;
    //    newFrame.size.width = widthIs;
    //    newFrame.origin.x = x;
    //    newFrame.origin.y = y;
    //    label.frame = newFrame;
    //    [label setFrame:newFrame];
    return label;
}


- (UIView*) createFilterViewWithArray:(NSArray*)filterArray{
    
    UIView* filterBox = [[UIView alloc] init];
    
    int x   =   0;
    int y = 0;
//    CGFloat width = 100.0f;
    
    for(MapFilterUiModel *filterModel in filterArray) {
        UIView *filterControl = [[UIView alloc] init];
        [filterControl setUserInteractionEnabled:NO];
        UIImage *uiImageSelected =  filterModel.checkboxSelectedImage;
        UIImage *uiImageUnselected =  filterModel.checkboxUnselectedImage;
        UIImage *circleImage = filterModel.circleImage;
        NSString* labelText = filterModel.labelText;
        
        UIView *checkboxView =  [self createCheckbox:uiImageSelected uiImageUnselected:uiImageUnselected isSelected:true x:x y:y];
        x                   =   x +checkboxView.frame.size.width+ CHECKBOX_MARGIN_RIGHT + CIRCLE_MARGIN_LEFT;
        UIView *circleView  =   [self createCircle:circleImage x:x y:y];
        x                   =   x + circleView.frame.size.width + CIRCLE_MARGIN_RIGHT + LABEL_MARGIN_LEFT;
        UIView *labelView   =   [self createLabel:labelText x:x y:y];
        x                   =   x + labelView.frame.size.width + LABEL_MARGIN_RIGHT;
        int filterControlWidth = CHECKBOX_FRAME_WIDTH_HEIGHT + CIRCLE_FRAME_WIDTH_HEIGHT +labelView.frame.size.width + CHECKBOX_MARGIN_RIGHT + CIRCLE_MARGIN_LEFT +CIRCLE_MARGIN_RIGHT + LABEL_MARGIN_LEFT + LABEL_MARGIN_RIGHT;
        [filterControl setFrame:CGRectMake(x, y, filterControlWidth, checkboxView.frame.size.height + circleView.frame.size.height + labelView.frame.size.height)];

        self->x = x;
        self->y = y;
        self->width = filterControl.frame.size.width;
        self->height = filterControl.frame.size.height;
        [filterControl addSubview:checkboxView];
        [filterControl addSubview:circleView];
        [filterControl addSubview:labelView];
        
        [filterBox addSubview:filterControl];
        [filterBox setBackgroundColor:[UIColor greenColor]];
    }
    return filterBox;
}


- (void)createFilterViewWithArrayData:(NSArray*)filterArray{
    
    for (NSArray *filterTitles in filterArray) {

        UIView *filterBox= [self createFilterViewWithArray:filterTitles];
        
        [filterBox setFrame:CGRectMake(x, y, width, height)];
        [filterBox setBackgroundColor:[UIColor blueColor]];
        [self addSubview: filterBox];
    }
}


-(void)setFilters:(NSArray *)filters {
    _filters = filters;
    [self createFilterViewWithArrayData:filters];
}

@end
