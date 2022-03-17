#import <UIKit/UIKit.h>

/**
 Activity indicator as used by PurchaseButton. Shows a rotating arc.
 */
@interface PurchaseActivityIndicatorView : UIView

@property (nonatomic, assign) CGFloat lineWidth;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@end
