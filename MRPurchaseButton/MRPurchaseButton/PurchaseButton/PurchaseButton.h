#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PurchaseButtonState)
{
	PurchaseButtonStateNormal,		// normal, colored button
	PurchaseButtonStateConfirmation,	// confirmation button, using the confirmationTitle/Color
	PurchaseButtonStateProgress,		// progress indicator state
};

/**
 @abstract A button which toggles between different states
 */
IB_DESIGNABLE
@interface PurchaseButton : UIControl

@property (nonatomic, assign) IBInspectable PurchaseButtonState buttonState;
-(void)setButtonState:(PurchaseButtonState)buttonState animated:(BOOL)animated;

@property (nonatomic, strong) IBInspectable UIImage* image;

//Button font
@property (nonatomic, strong) IBInspectable UIFont* titleLabelFont;

// normal state colors
@property (nonatomic, copy) IBInspectable NSString* normalTitle;
@property (nonatomic, copy) IBInspectable NSAttributedString* attributedNormalTitle;
@property (nonatomic, retain) IBInspectable UIColor* normalColor; // needed, equals tintColor

// confirmation state colors
@property (nonatomic, copy) IBInspectable NSString* confirmationTitle;
@property (nonatomic, copy) IBInspectable NSAttributedString* attributedConfirmationTitle;
@property (nonatomic, retain) IBInspectable UIColor* confirmationColor;

@end
