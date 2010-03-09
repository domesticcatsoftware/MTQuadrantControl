MTQuadrantControl
=================

## A 4-way button disguised as a table cell, as seen in Tweetie 2


## Demo

After cloning the repository, open the Xcode Project file <tt>/MTQuadrantControl/Example/Nitwit.xcodeproj</tt>. Build and Run in the iPhone Simulator to see it in action. The specified quadrant actions are stubbed out as an example.

## Usage

Initialize as follows in a UITableViewController or subclass (works best with table views with a <strong>grouped</strong> style):

<code>
  MTQuadrantControl * quadrantControl = [[[MTQuadrantControl alloc] initWithFrame:CGRectMake(10, 20, 300, 90)] autorelease];
	quadrantControl.delegate = self;
	
	[quadrantControl setNumber:[NSNumber numberWithInt:127]
					   caption:@"following"
						action:@selector(didSelectFollowingQuadrant)
				   forLocation:TopLeftLocation];
	
	[quadrantControl setNumber:[NSNumber numberWithInt:1728]
					   caption:@"tweets" 
						action:@selector(didSelectTweetsQuadrant)
				   forLocation:TopRightLocation];
	
	[quadrantControl setNumber:[NSNumber numberWithInt:352] 
					   caption:@"followers" 
						action:@selector(didSelectFollowersQuadrant)
				   forLocation:BottomLeftLocation];
	
	[quadrantControl setNumber:[NSNumber numberWithInt:61] 
					   caption:@"favorites" 
						action:@selector(didSelectFavoritesQuadrant)
				   forLocation:BottomRightLocation];
	
	[self.tableSectionFooterView addSubview:quadrantControl];
</code>

- <tt>number</tt> - the number displayed at top
- <tt>caption</tt> - the text displayed below the number
- <tt>action</tt> - a selector to be performed by the delegate
- <tt>location</tt> - the specified quadrant to set these values and action for ([TopLeftLocation|TopRightLocation|BottomLeftLocation|BottomRightLocation])

## Requirements

- iPhone OS 3.0 or higher
- QuartzCore framework

## Issues

In its current release, the horizontal and vertical dividing lines in the quadrant control appear to be drawing between pixel boundaries. If you are handy with CoreGraphics and can fix this, I would greatly appreciate it.

## License

MTQuadrantControl is licensed under the MIT License:

  Copyright (c) 2010 Mattt Thompson (http://mattt.me/)

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  
## Credit

Inspired entirely by [Tweetie 2 for iPhone](http://www.atebits.com/tweetie-iphone/), by [atebits](http://www.atebits.com/)