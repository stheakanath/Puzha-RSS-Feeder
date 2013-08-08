//
//  RootViewController.m
//  Puzha RSS Feeder
//
//  Created by Sony Theakanath on 4/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated]; if ([stories count] == 0) { NSString * path = @"http://rss.cnn.com/rss/cnn_topstories.rss"; [self parseXMLFileAtURL:path]; } cellSize = CGSizeMake([newsTable bounds].size.width, 60); 
}

- (void)parseXMLFileAtURL:(NSString *)URL { stories = [[NSMutableArray alloc] init]; 
    //you must then convert the path to a proper NSURL or it won't work 
    NSURL *xmlURL = [NSURL URLWithString:URL]; 
    // here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
    // this may be necessary only for the toolchain 
    rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL]; 
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks. 
    [rssParser setDelegate:self]; 
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser. 
    [rssParser setShouldProcessNamespaces:NO]; [rssParser setShouldReportNamespacePrefixes:NO]; [rssParser setShouldResolveExternalEntities:NO]; [rssParser parse]; }

- (void)parserDidStartDocument:(NSXMLParser *)parser { NSLog(@"found file and started parsing"); } - (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError { NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]]; NSLog(@"error parsing XML: %@", errorString); UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]; [errorAlert show]; } - (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{(@"found this element: %@", elementName); currentElement = [elementName copy]; if ([elementName isEqualToString:@"item"]) { // clear out our story item caches... item = [[NSMutableDictionary alloc] init]; currentTitle = [[NSMutableString alloc] init]; currentDate = [[NSMutableString alloc] init]; currentSummary = [[NSMutableString alloc] init]; currentLink = [[NSMutableString alloc] init]; } } - (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{ //NSLog(@"ended element: %@", elementName); if ([elementName isEqualToString:@"item"]) { // save values to an item, then store that item into the array... [item setObject:currentTitle forKey:@"title"]; [item setObject:currentLink forKey:@"link"]; [item setObject:currentSummary forKey:@"summary"]; [item setObject:currentDate forKey:@"date"]; [stories addObject:[item copy]]; NSLog(@"adding story: %@", currentTitle); } } - (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{ //NSLog(@"found characters: %@", string); // save the characters for the current item... if ([currentElement isEqualToString:@"title"]) { [currentTitle appendString:string]; } else if ([currentElement isEqualToString:@"link"]) { [currentLink appendString:string]; } else if ([currentElement isEqualToString:@"description"]) { [currentSummary appendString:string]; } else if ([currentElement isEqualToString:@"pubDate"]) { [currentDate appendString:string]; } } - (void)parserDidEndDocument:(NSXMLParser *)parser { [activityIndicator stopAnimating]; [activityIndicator removeFromSuperview]; NSLog(@"all done!"); NSLog(@"stories array has %d items", [stories count]); [newsTable reloadData]; 
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [stories count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier: MyIdentifier] autorelease]; }
    // Set up the cell
    int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1]; [cell setText:[[stories objectAtIndex: storyIndex] objectForKey: @"title"]]; return cell; }
    // Configure the cell.
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	*/
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

@end
