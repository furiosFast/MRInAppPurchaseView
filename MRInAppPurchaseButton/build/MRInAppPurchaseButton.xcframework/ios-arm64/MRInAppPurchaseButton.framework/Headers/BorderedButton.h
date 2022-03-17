#import <UIKit/UIKit.h>

// defaults
extern CGFloat kBorderedButtonDefaultBorderWidth;
extern CGFloat kBorderedButtonDefaultCornerRadius;

/*!
 @abstract Button that has a border and fills itself on highlighting.
 
 Use the .title property to change the title of this button.
 */
IB_DESIGNABLE
@interface BorderedButton : UIControl

// title for this button - no differences between states
@property (nonatomic, copy) IBInspectable NSString* title;
@property (nonatomic, copy) IBInspectable NSAttributedString* attributedTitle;
@property (nonatomic, strong) IBInspectable UIImage* image;

// title properties
@property (nonatomic, readonly) UILabel* titleLabel; // don't set .text property directly, use .title
@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets;

// looks, animates when updated
@property (nonatomic, assign) IBInspectable CGFloat borderWidth; // defaults to kBorderedButtonDefaultBorderWidth (animatable)
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius; // defaults to kBorderedButtonDefaultCornerRadius (animatable)

@end
