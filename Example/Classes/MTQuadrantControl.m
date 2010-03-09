// MTQuadrantControl.m
//
// Copyright (c) 2010 Mattt Thompson
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in 
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
// SOFTWARE.


#import "MTQuadrantControl.h"

@implementation MTQuadrantControl

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		float width = round(frame.size.width / 2.0);
		float height = round(frame.size.height / 2.0);
		
		activeLocation = NullQuadrant;
		
		self.backgroundColor = [UIColor whiteColor];
		self.layer.cornerRadius = 8.0f;
		self.layer.borderWidth = 1.0f;
		self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		self.layer.masksToBounds = YES;
		
		topLeftQuadrant = [[MTQuadrantView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
		topRightQuadrant = [[MTQuadrantView alloc] initWithFrame:CGRectMake(width, 0.0f, width, height)];
		bottomLeftQuadrant = [[MTQuadrantView alloc] initWithFrame:CGRectMake(0.0f, height, width, height)];
		bottomRightQuadrant = [[MTQuadrantView alloc] initWithFrame:CGRectMake(width, height, width, height)];
		
		[self addSubview:topLeftQuadrant];
		[self addSubview:topRightQuadrant];
		[self addSubview:bottomLeftQuadrant];
		[self addSubview:bottomRightQuadrant];
    }
	
    return self;
}

- (MTQuadrantView *)quadrantAtLocation:(MTQuadrantLocation)location {
	switch (location) {
		case TopLeftLocation: 
			return topLeftQuadrant;
		case TopRightLocation: 
			return topRightQuadrant;
		case BottomLeftLocation:
			return bottomLeftQuadrant;
		case BottomRightLocation: 
			return bottomRightQuadrant;
		default: 
			return nil;
	}
}

- (void)setNumber:(NSNumber *)number 
		  caption:(NSString *)caption 
		   action:(SEL)action
	  forLocation:(MTQuadrantLocation)location 
{
	MTQuadrantView * quadrantView = [self quadrantAtLocation:location];
	quadrantView.number = number;
	quadrantView.caption = caption;
	quadrantView.action = action;
}

- (MTQuadrantLocation)locationAtPoint:(CGPoint)point {
	CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
	if (point.x < center.x) {
		if (point.y < center.y) {
			return TopLeftLocation;
		} else {
			return BottomLeftLocation;
		}
	}
	else {
		if (point.y < center.y) {
			return TopRightLocation;
		} else {
			return BottomRightLocation;
		}
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch * touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	
	activeLocation = [self locationAtPoint:point];
	[self setNeedsDisplay];
	[[self subviews] makeObjectsPerformSelector:@selector(setNeedsDisplay)];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	switch (activeLocation) {
		case TopLeftLocation:
		case TopRightLocation: 
		case BottomLeftLocation:
		case BottomRightLocation:
			[delegate performSelector:[[self quadrantAtLocation:activeLocation] action]];
	}
	
	activeLocation = NullQuadrant;
	[self setNeedsDisplay];
	[[self subviews] makeObjectsPerformSelector:@selector(setNeedsDisplay)];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	activeLocation = NullQuadrant;
	[self setNeedsDisplay];
	[[self subviews] makeObjectsPerformSelector:@selector(setNeedsDisplay)];
}

- (void)drawRect:(CGRect)rect {	
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	// Background Fill
	CGContextSetFillColorWithColor(c, [[UIColor whiteColor] CGColor]);
	CGContextFillRect(c, rect);
	
	// Vertical Divider
	CGContextMoveToPoint(c, round(CGRectGetMidX(rect)), 0.0f);
	CGContextAddLineToPoint(c, round(CGRectGetMidX(rect)), round(rect.size.height));
	
	// Horizontal Divider
	CGContextMoveToPoint(c, 0.0f, round(CGRectGetMidY(rect)));
	CGContextAddLineToPoint(c, round(rect.size.width), round(CGRectGetMidY(rect)));
	
	// TODO: Seems to be drawing on a pixel border; 1px crisp line would be ideal
	CGContextSetLineWidth(c, 0.5f);
	CGContextSetStrokeColorWithColor(c, [[UIColor lightGrayColor] CGColor]);
	CGContextDrawPath(c, kCGPathStroke);      
    
	[topLeftQuadrant setHighlighted:NO];
	[topRightQuadrant setHighlighted:NO];
	[bottomLeftQuadrant setHighlighted:NO];
	[bottomRightQuadrant setHighlighted:NO];
	
	// Draw gradient background for selected quadrant
	if (activeLocation != NullQuadrant) {
		CGRect activeRect;
		
		switch (activeLocation) {
			case TopLeftLocation:
				topLeftQuadrant.highlighted = YES;
				activeRect = topLeftQuadrant.frame;
				break;
			case TopRightLocation: 
				topRightQuadrant.highlighted = YES;
				activeRect = topRightQuadrant.frame;
				break;
			case BottomLeftLocation:
				bottomLeftQuadrant.highlighted = YES;
				activeRect = bottomLeftQuadrant.frame;
				break;
			case BottomRightLocation:
				bottomRightQuadrant.highlighted = YES;
				activeRect = bottomRightQuadrant.frame;
				break;
		}
		
		size_t num_locations = 2;
		CGFloat locations[2] = {0.0, 1.0};
		CGFloat components[8] = {0.000, 0.459, 0.968, 1.000,	//	#0075F6
								 0.000, 0.265, 0.897, 1.000};	//	#0043E4
		
		CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
		
		CGContextClipToRect(c, *(CGRect *)&activeRect);
		CGContextDrawLinearGradient(c, gradient, 
									CGPointMake(CGRectGetMidX(activeRect), CGRectGetMinY(activeRect)), 
									CGPointMake(CGRectGetMidX(activeRect), CGRectGetMaxY(activeRect)), 0);
		
		CGColorSpaceRelease(rgbColorspace);
		CGGradientRelease(gradient);
	}
}

- (void)dealloc {
	[topLeftQuadrant release];
	[topRightQuadrant release];
	[bottomLeftQuadrant release];
	[bottomRightQuadrant release];
    [super dealloc];
}

@end

static NSNumberFormatter * numberFormatter;

@implementation MTQuadrantView

@synthesize number, caption, highlighted, action;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {	
		self.highlighted = NO;
		self.opaque = NO;
    }
	
    return self;
}

- (void)drawRect:(CGRect)rect {
	[(self.highlighted ? [UIColor whiteColor] : [UIColor blackColor]) set];
	NSString * numberString = [self.numberFormatter stringFromNumber:self.number];
	CGSize numberTextSize = [numberString sizeWithFont:[UIFont boldSystemFontOfSize:24]
												  constrainedToSize:self.bounds.size];
	CGPoint numberDrawPoint = CGPointMake(round((self.bounds.size.width - numberTextSize.width) / 2.0), 3.0f);
	[numberString drawAtPoint:numberDrawPoint 
					 withFont:[UIFont boldSystemFontOfSize:24]];
	
	[(self.highlighted ? [UIColor whiteColor] : [UIColor darkGrayColor]) set];
	CGSize captionTextSize = [self.caption sizeWithFont:[UIFont boldSystemFontOfSize:12]
									  constrainedToSize:self.bounds.size];
	CGPoint captionDrawPoint = CGPointMake(round((self.bounds.size.width - captionTextSize.width) / 2.0), 28.0f);
	[self.caption drawAtPoint:captionDrawPoint 
					 withFont:[UIFont boldSystemFontOfSize:12]];
}

- (NSNumberFormatter *)numberFormatter {
	if (numberFormatter == nil) {
		numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	}
	
	return numberFormatter;
}

- (void)dealloc {
	[number release];
	[caption release];
	[super dealloc];
}

@end
