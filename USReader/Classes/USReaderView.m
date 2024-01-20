//
//  USReaderView.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/6.
//

#import "USReaderView.h"
#import <CoreText/CoreText.h>
#import "USCoreText.h"
#import "USConstants.h"

@interface USReaderView ()

@property (nonatomic, assign) CTFrameRef frameRef;

@property (nonatomic, strong) NSAttributedString *content;

@end

@implementation USReaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setFrameRef:(CTFrameRef)frameRef {
    _frameRef = frameRef;
    [self setNeedsDisplay];
}

- (void)setContent:(NSAttributedString *)content {
    _content = content;
    self.frameRef = [USCoreText GetFrameRef:content rect:CGRectMake(0, 0, US_READERRECT.size.width, US_READERRECT.size.height)];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.frameRef == nil) {
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CTFrameDraw(self.frameRef, ctx);
}

@end
