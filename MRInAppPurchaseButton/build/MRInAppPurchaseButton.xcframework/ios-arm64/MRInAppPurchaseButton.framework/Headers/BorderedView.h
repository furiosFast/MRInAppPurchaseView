#import <UIKit/UIKit.h>

/*!
 @abstract view that has a border and a cornerRadius.
 
 Use the .title property to change the title of this button.
 */
IB_DESIGNABLE
@interface BorderedView : UIView

@property (nonatomic, strong) IBInspectable UIColor* borderColor; // animatable
@property (nonatomic, assign) IBInspectable CGFloat borderWidth; // animatable
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius; // animatable

@end
