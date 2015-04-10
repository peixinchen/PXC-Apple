#import "Arrow.h"

@implementation Arrow

- (UIColor *)arrowColor {
    if (!_arrowColor) {
        _arrowColor = [UIColor blackColor];
    }

    return _arrowColor;
}

- (void)drawRect:(CGRect)rect {
    CGFloat widthRatio = rect.size.width / 22;
    CGFloat heightRatio = rect.size.height / 48;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextAddRect(c, CGRectMake(5 * widthRatio, 0 * heightRatio, 12 * widthRatio, 4 * heightRatio));
    CGContextAddRect(c, CGRectMake(5 * widthRatio, 6 * heightRatio, 12 * widthRatio, 4 * heightRatio));
    CGContextAddRect(c, CGRectMake(5 * widthRatio, 12 * heightRatio, 12 * widthRatio, 4 * heightRatio));
    CGContextAddRect(c, CGRectMake(5 * widthRatio, 18 * heightRatio, 12 * widthRatio, 4 * heightRatio));
    CGContextAddRect(c, CGRectMake(5 * widthRatio, 24 * heightRatio, 12 * widthRatio, 4 * heightRatio));
    CGContextAddRect(c, CGRectMake(5 * widthRatio, 30 * heightRatio, 12 * widthRatio, 4 * heightRatio));

    CGContextMoveToPoint(c, 0 * widthRatio, 34 * heightRatio);
    CGContextAddLineToPoint(c, 11 * widthRatio, 48 * heightRatio);
    CGContextAddLineToPoint(c, 22 * widthRatio, 34 * heightRatio);
    CGContextAddLineToPoint(c, 0 * widthRatio, 34 * heightRatio);
    CGContextClosePath(c);
    
    CGContextSaveGState(c);
    CGContextClip(c);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat alphaGradientLocations[] = {0, 0.8f};
    
    CGGradientRef alphaGradient = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f) {
        NSArray *alphaGradientColors = [NSArray arrayWithObjects:
                                        (id)[self.arrowColor colorWithAlphaComponent:0].CGColor,
                                        (id)[self.arrowColor colorWithAlphaComponent:1].CGColor,
                                        nil];
        alphaGradient = CGGradientCreateWithColors(colorSpace,
                                                   (__bridge CFArrayRef)alphaGradientColors,
                                                   alphaGradientLocations);
    } else {
        const CGFloat *components = CGColorGetComponents([self.arrowColor CGColor]);
        size_t numComponents = CGColorGetNumberOfComponents([self.arrowColor CGColor]);
        CGFloat colors[8];
        
        switch (numComponents) {
            case 2: {
                colors[0] = colors[4] = components[0];
                colors[1] = colors[5] = components[0];
                colors[2] = colors[6] = components[0];
                break;
            }
                
            case 4: {
                colors[0] = colors[4] = components[0];
                colors[1] = colors[5] = components[1];
                colors[2] = colors[6] = components[2];
                break;
            }
        }
        
        colors[3] = 0;
        colors[7] = 1;
        alphaGradient = CGGradientCreateWithColorComponents(colorSpace,colors,
                                                            alphaGradientLocations, 2);
    }
    
    CGContextDrawLinearGradient(c, alphaGradient, CGPointZero,
                                CGPointMake(0, rect.size.height), 0);
    
    CGContextRestoreGState(c);
    
    CGGradientRelease(alphaGradient);
    CGColorSpaceRelease(colorSpace);
}

@end

