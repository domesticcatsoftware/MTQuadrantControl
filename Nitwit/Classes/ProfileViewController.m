// ProfileViewController.m
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

#import "ProfileViewController.h"
#import "MTQuadrantControl.h"


typedef enum {
	InformationSectionIndex,
} ProfileSectionIndicies;

typedef enum {
	BioRowIndex,
	LocationRowIndex,
	WebsiteRowIndex,
} InformationSectionRowIndicies;


@implementation ProfileViewController

@synthesize tableSectionFooterView;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	avatarView.layer.cornerRadius = 8.0f;
	avatarView.layer.borderWidth = 1.0f;
	avatarView.layer.masksToBounds = YES;
	avatarView.layer.borderColor = [[UIColor clearColor] CGColor];
	
	self.tableSectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 140)];
	
	MTQuadrantControl * quadrantControl = [[[MTQuadrantControl alloc] initWithFrame:CGRectMake(10, 20, 300, 100)] autorelease];
	quadrantControl.delegate = self;
	
	[quadrantControl setNumber:[NSNumber numberWithInt:127]
					   caption:@"following"
						action:@selector(didSelectQuadrant)
				   forLocation:TopLeftLocation];
	
	[quadrantControl setNumber:[NSNumber numberWithInt:1728]
					   caption:@"tweets" 
						action:@selector(didSelectQuadrant)
				   forLocation:TopRightLocation];
	
	[quadrantControl setNumber:[NSNumber numberWithInt:352] 
					   caption:@"followers" 
						action:@selector(didSelectQuadrant)
				   forLocation:BottomLeftLocation];
	
	[quadrantControl setNumber:[NSNumber numberWithInt:61] 
					   caption:@"favorites" 
						action:@selector(didSelectQuadrant)
				   forLocation:BottomRightLocation];
	
	[self.tableSectionFooterView addSubview:quadrantControl];
}

#pragma mark -
#pragma mark Actions

- (void)didSelectQuadrant {
	NSLog(@"didTouchQuadrant");
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case BioRowIndex:
		case LocationRowIndex:
		case WebsiteRowIndex:
		default:
			return 44.0f;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	switch (section) {
		case InformationSectionIndex:
			return self.tableSectionFooterView;
		default:
			return nil;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	switch (section) {
		case InformationSectionIndex:
			return self.tableSectionFooterView.bounds.size.height;
		default:
			return 0.0f;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = nil;
	
	switch (indexPath.row) {
		case BioRowIndex:
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
										   reuseIdentifier:nil] autorelease];
			cell.textLabel.text = @"Hacker from the Rustbelt, living in Texas.";
			cell.textLabel.font = [UIFont systemFontOfSize:14];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			break;
		case LocationRowIndex:
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 
										   reuseIdentifier:nil] autorelease];
			cell.textLabel.text = @"location";
			cell.detailTextLabel.text = @"Austin, TX";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case WebsiteRowIndex:
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 
										   reuseIdentifier:nil] autorelease];
			cell.textLabel.text = @"web";
			cell.detailTextLabel.text = @"http://mattt.me";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
	}
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Memory management


- (void)viewDidUnload {
    avatarView = nil;
}

- (void)dealloc {
	[tableSectionFooterView release];
    [super dealloc];
}


@end

