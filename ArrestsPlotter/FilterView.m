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

#import <Foundation/Foundation.h>
#import "FilterView.h"
#import "MapFilterUiModel.h"

@implementation FilterView

@synthesize x;
@synthesize y;
@synthesize width;
@synthesize height;
@synthesize margin;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         margin = 0;
        x = 0;
        y = 0;
        width = frame.size.width;
        height = frame.size.height;
        self.opaque = NO;
       
    }
    return self;
}

-(id)initCustom {
    
    return self;
}

-(void) drawRect: (CGRect) rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * redColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9];
    CGContextSetFillColorWithColor(context, redColor.CGColor);
    CGContextFillRect(context, self.bounds);
}


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
    //    CGColorRef*  aqua = [[UIColor colorWithRed:0.521569 green:0.768627 blue:0.254902 alpha:1] CGColor];
    //    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    //    CGContextSetLineWidth(contextRef, 2.0);
    //    CGContextSetStrokeColorWithColor(contextRef, pixelColor);
    CGRect circlePoint = (CGRectMake(x, y, CIRCLE_FRAME_WIDTH_HEIGHT, CIRCLE_FRAME_WIDTH_HEIGHT));
    
    UIImageView *uiImageView = [[UIImageView alloc]initWithFrame:(circlePoint)];
    [uiImageView setImage:circleImage];
//    uiImageView.frame = CGRectMake(x, y, 8, 8);
    return uiImageView;
}

// method for creating the label
- (UIView*) createLabel:(NSString*)labelText  x:(int) x y:(int) y{
    //I have to figure out how to get the lable width and height in advance.
//    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(x, y, MAX_LABEL_WIDTH, MAX_LABEL_HEIGHT)];//Set frame of label in your viewcontroller.
//    label.translatesAutoresizingMaskIntoConstraints = NO;
//    [label addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[label]-(10)-|" options:0 metrics:nil views:@{@"label":label}]];  // horizontal constraint
//    [label addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[label]" options:0 metrics:nil views:@{@"label":label}]];
    UILabel *labelForSize=[[UILabel alloc]init];
    [labelForSize setText:labelText];//Set text in label.
    [labelForSize setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    CGRect yourLabelSize = [labelText
                            boundingRectWithSize:labelForSize.frame.size
                            options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{ NSFontAttributeName:labelForSize.font }
                            context:nil];
    
//    float widthIs =
//    [labelText
//     boundingRectWithSize:label.frame.size
//     options:NSStringDrawingUsesLineFragmentOrigin
//     attributes:@{ NSFontAttributeName:label.font }
//     context:nil]
//    .size.width;


    
//    label.frame.size = yourLabelSize.size;
    
//    CGSize yourLabelSize = [label.text sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:label.font size:label.size]}];
    y= (y - yourLabelSize.size.height)/2;
    NSLog(@"x:  %d", x);
    NSLog(@"y:  %d", y);
    NSLog(@"width:  %f", yourLabelSize.size.width);
    NSLog(@"height:  %f", yourLabelSize.size.height);
    
  UILabel  *label =[[UILabel alloc] initWithFrame:CGRectMake(x,y, yourLabelSize.size.width,yourLabelSize.size.height )]; // RectMake(xPos,yPos,Max Width I want, is just a container value);
   /*
    label.text = labelText;
    label.numberOfLines = 0; //will wrap text in new line
    CGSize maximumLabelSize = CGSizeMake(labelText.length*11, FLT_MAX);
    [label sizeThatFits:maximumLabelSize];
*/
    
//    CGSize maxSize = CGSizeMake(FLT_MIN, FLT_MAX);
//    CGRect labRect = [labelText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil];
//    
//    label.frame = CGRectMake(0, 0, maxSize.width, labRect.size.height);
//    label.text = labelText;
    
    
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
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
//    CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
////
//    CGSize expectedLabelSize = [labelText sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:label.lineBreakMode];
    
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


- (UIView*) createFilterView:(NSMutableArray*)filterArray{
    int oldy = y;
    for(MapFilterUiModel *filterModel in filterArray) {
        UIImage *uiImageSelected =  filterModel.checkboxSelectedImage;
        UIImage *uiImageUnselected =  filterModel.checkboxUnselectedImage;
        UIImage *circleImage = filterModel.circleImage;
        NSString* labelText = filterModel.labelText;

        x   =   x   +   CHECKBOX_MARGIN_LEFT;
        y   =   oldy+ (height-CHECKBOX_FRAME_WIDTH_HEIGHT)/2;
        // creating the checkbox
        UIView *checkboxView = [self createCheckbox:uiImageSelected uiImageUnselected:uiImageUnselected isSelected:true x:x y:y];
        x= x+checkboxView.frame.size.width+ CHECKBOX_MARGIN_RIGHT + CIRCLE_MARGIN_LEFT;
        y = oldy+(height - CIRCLE_FRAME_WIDTH_HEIGHT)/2;
        // creating the circle
        UIView *circleView = [self createCircle:circleImage x:x y:y];
        x= x + circleView.frame.size.width + CIRCLE_MARGIN_RIGHT + LABEL_MARGIN_LEFT;
        y=oldy + height;
//        y=oldy ;//+ LABEL_FRAME_MARGIN_HEIGHT;
        // creating the Label
        UIView *labelView = [self createLabel:labelText x:x y:y];
        x= x + labelView.frame.size.width + LABEL_MARGIN_RIGHT;
        
        [self addSubview:checkboxView];
        [self addSubview:circleView];
        [self addSubview:labelView];
        y=oldy;

    }
    return self;
}

@end
