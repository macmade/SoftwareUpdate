/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        MainViewController.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "MainViewController.h"
#import "ApplicationDelegate.h"
#import "HostReachabilityTest.h"
#import "UpdateFeed.h"
#import "DetailViewController.h"
#import "TableViewRefresh.h"

static BOOL __alertDisplayed = NO;

@implementation MainViewController

@synthesize tableView;

- ( id )initWithCoder: ( NSCoder * )coder
{
    if( ( self = [ super initWithCoder: coder ] ) )
    {}
    
    return self;
}

- ( id )initWithNibName: ( NSString * )nibNameOrNil bundle: ( NSBundle * )nibBundleOrNil
{
    if( ( self = [ super initWithNibName: nibNameOrNil bundle: nibBundleOrNil ] ) )
    {}
    
    return self;
}

- ( void )dealloc
{
    [ feed        release ];
    [ tableView   release ];
    [ adView      release ];
    [ refreshView release ];
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{}

- ( void )refresh
{
    [ feed release ];
    
    feed = [ [ UpdateFeed alloc ] initWithFeedURL: feedURL ];
    
    [ NSThread detachNewThreadSelector: @selector( loadData ) toTarget: feed withObject: nil ];
    
    while( feed.dataLoaded == NO )
    {}
    
    [ tableView reloadData ];
}

- ( void )hideIAd
{
    if( adViewVisible == YES )
    {
        [ adView removeFromSuperview ];
        [ adView release ];
        
        adView          = nil;
        tableView.frame = self.view.frame;
        adViewVisible   = NO;
    }
}

- ( void )viewDidLoad
{
    tableView.rowHeight = 50;
    
    if( refreshView == nil )
    {
        refreshView                                         = [ [ TableViewRefresh alloc ] initWithFrame: CGRectMake( ( CGFloat )0.0, ( CGFloat )0.0 - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height ) ];
        refreshView.delegate                                = self;
        refreshView.backgroundColor                         = [ UIColor blackColor ];
        refreshView.statusLabel.textColor                   = [ UIColor whiteColor ];
        refreshView.lastUpdatedLabel.textColor              = [ UIColor whiteColor ];
        refreshView.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite,
        
        [ refreshView setArrowType: TableViewHeaderArrowTypeWhite ];
        
        [ self.tableView addSubview: refreshView ];
    }
}

- ( void )viewWillAppear: ( BOOL )animated
{
    HostReachabilityTest * test;
    UIAlertView          * alert;
    
    [ super viewDidLoad ];
    
    test = [ HostReachabilityTest testWithHost: @"feeds.feedburner.com" ];
    
    if( [ test isReachable ] == NO && __alertDisplayed == NO )
    {
        __alertDisplayed = YES;
        alert            = [ [ UIAlertView alloc ] initWithTitle: @"No network" message: @"A network connection is required in order to use this application." delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil ];
        
        [ alert show ];
        [ alert release ];
        [ [ UIApplication sharedApplication ] setNetworkActivityIndicatorVisible: NO ];
        
        return;
    }
    else if( __alertDisplayed == NO )
    {
        [ self refresh ];
    }
    
    [ super viewWillAppear: animated ];
    
    adView          = [ [ ADBannerView alloc ] initWithFrame: CGRectMake( 0, 0, 1, 1) ];
    adView.delegate = self;
    adView.alpha    = 0;
    adViewVisible   = NO;
    
    if( 0 && ( [ [ UIDevice currentDevice ] orientation ] == UIInterfaceOrientationLandscapeLeft || [ [ UIDevice currentDevice ] orientation ] == UIInterfaceOrientationLandscapeRight ) )
    {
        [ adView setCurrentContentSizeIdentifier: ADBannerContentSizeIdentifierLandscape ];
    }
    else
    {
        [ adView setCurrentContentSizeIdentifier: ADBannerContentSizeIdentifierPortrait ];
    }
    
    [ self.view addSubview: adView ];
}

- ( void )viewDidAppear: ( BOOL )animated
{
    [ super viewDidAppear: animated ];
}

- ( void )viewWillDisappear: ( BOOL )animated
{
	[ super viewWillDisappear: animated ];
}

- ( void )viewDidDisappear: ( BOOL )animated
{
	[ super viewDidDisappear: animated ];
    [ adView removeFromSuperview ];
    [ adView release ];
    
    adView          = nil;
    tableView.frame = self.view.frame;
    adViewVisible   = NO;
}

- ( void )didReceiveMemoryWarning
{
    [ super didReceiveMemoryWarning ]; 
}

- (void)viewDidUnload
{
    [ super viewDidUnload ];
}

- ( BOOL )shouldAutorotateToInterfaceOrientation: ( UIInterfaceOrientation )interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- ( void )willRotateToInterfaceOrientation: ( UIInterfaceOrientation )toInterfaceOrientation duration:( NSTimeInterval )duration
{
    CGRect frame;
    
    ( void )duration;
    
    if( adViewVisible == NO )
    {
        return;
    }
    
    if( toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight )
    {
        [ adView setCurrentContentSizeIdentifier: ADBannerContentSizeIdentifierLandscape ];
    }
    else
    {
        [ adView setCurrentContentSizeIdentifier: ADBannerContentSizeIdentifierPortrait ];
    }
    
    frame              = self.view.frame;
    frame.size.height -= adView.frame.size.height;
    frame.origin.y    += adView.frame.size.height;
    tableView.frame    = frame;
}

- ( void )bannerView: ( ADBannerView * )banner didFailToReceiveAdWithError: ( NSError * )error
{
    ( void )banner;
    ( void )error;
}

- ( void )bannerViewDidLoadAd: ( ADBannerView * )banner
{
    CGRect frame;
    
    if( adViewVisible == YES )
    {
        return;
    }
    
    frame = tableView.frame;
    
    [ UIView beginAnimations: nil context: NULL ];
    [ UIView setAnimationDuration: 1 ];
    [ banner setAlpha: ( CGFloat )1 ];
    
    frame.size.height -= banner.frame.size.height;
    frame.origin.y    += banner.frame.size.height;
    
    [ tableView setFrame: frame ];
    [ UIView commitAnimations ];
    
    adViewVisible = YES;
    
}

- ( void )alertView: ( UIAlertView * )alertView didDismissWithButtonIndex: ( NSInteger )buttonIndex
{
    ( void )alertView;
    ( void )buttonIndex;
}

- ( NSInteger )numberOfSectionsInTableView: ( UITableView * )table
{
    ( void )table;
    
    return 1;
}

- ( NSInteger )tableView: ( UITableView * )table numberOfRowsInSection: ( NSInteger )section
{
    ( void )table;
    ( void )section;
    
    return [ feed.updates count ];
}

- ( UITableViewCell * )tableView: ( UITableView * )table cellForRowAtIndexPath: ( NSIndexPath * )indexPath
{
    static NSString * CellIdentifier = @"Cell";
    UITableViewCell * cell;
    NSDictionary    * app;
    UIImageView     * backgroundView;
    
    ( void )table;
    ( void )indexPath;
    
    cell = [ tableView dequeueReusableCellWithIdentifier: CellIdentifier ];
    
    if( cell == nil )
    {
        cell                           = [ [ UITableViewCell alloc ] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifier ];
        cell.textLabel.textColor       = [ UIColor colorWithHue: ( CGFloat )0.00 saturation: ( CGFloat )0.00 brightness: ( CGFloat )1.00 alpha: ( CGFloat )1.00 ];
        cell.detailTextLabel.textColor = [ UIColor colorWithHue: ( CGFloat )0.00 saturation: ( CGFloat )0.00 brightness: ( CGFloat )0.75 alpha: ( CGFloat )1.00 ];
        cell.accessoryType             = UITableViewCellAccessoryDisclosureIndicator;
        
        [ cell.textLabel       setFont: [ UIFont boldSystemFontOfSize: 16 ] ];
        [ cell.detailTextLabel setFont: [ UIFont systemFontOfSize: 12 ] ];
        
        backgroundView      = [ [ UIImageView alloc ] initWithImage: [ UIImage imageNamed: @"cell" ] ];
        cell.backgroundView = backgroundView;
        
        [ backgroundView autorelease ];
        [ cell autorelease ];
    }
    
    app                       = [ feed.updates objectAtIndex: indexPath.row ];
    cell.textLabel.text       = [ app objectForKey: @"title" ];
    cell.detailTextLabel.text = [ app objectForKey: @"description" ];
    
    return cell;
}

- ( BOOL )tableView: ( UITableView * )table canEditRowAtIndexPath: ( NSIndexPath * )indexPath
{
    ( void )table;
    ( void )indexPath;
    
    return NO;
}

- ( void )tableView: ( UITableView * )table commitEditingStyle: ( UITableViewCellEditingStyle )editingStyle forRowAtIndexPath: ( NSIndexPath * )indexPath
{
    ( void )table;
    ( void )indexPath;
    
    if( editingStyle == UITableViewCellEditingStyleDelete )
    {}
    else if( editingStyle == UITableViewCellEditingStyleInsert )
    {}   
}

- ( void )tableView: ( UITableView * )table moveRowAtIndexPath: ( NSIndexPath * )fromIndexPath toIndexPath: ( NSIndexPath * )toIndexPath
{
    ( void )table;
    ( void )fromIndexPath;
    ( void )toIndexPath;
}

- ( BOOL )tableView: ( UITableView * )table canMoveRowAtIndexPath: ( NSIndexPath * )indexPath
{
    ( void )table;
    ( void )indexPath;
    
    return NO;
}

- ( void )tableView: ( UITableView * )table didSelectRowAtIndexPath: ( NSIndexPath * )indexPath
{
    NSDictionary         * app;
    DetailViewController * viewController;
    
    ( void )table;
    ( void )indexPath;
    
    app            = [ feed.updates objectAtIndex: indexPath.row ];
    viewController = [ [ DetailViewController alloc ] initWithURL: [ app objectForKey: @"link" ] ];
    
    [ self.navigationController pushViewController: viewController animated: YES ];
    [ viewController release ];
}

- ( void )reloadTableViewDataSource
{
	reloading = YES;
    
    [ self refresh ];
}

- ( void )doneLoadingTableViewData
{
	
	reloading = NO;
    
	[ refreshView scrollViewDidFinishLoading: self.tableView ];
	
}

- ( void )scrollViewDidScroll: ( UIScrollView * )scrollView
{
	[ refreshView scrollViewDidScroll: scrollView ];
		
}

- ( void )scrollViewDidEndDragging: ( UIScrollView * )scrollView willDecelerate: ( BOOL )decelerate
{
    ( void )decelerate;
    
    [ refreshView scrollViewDidEndDragging: scrollView ];
	
}

- ( BOOL )tableViewIsLoading: ( TableViewRefresh * )view
{
    ( void )view;
    
    return reloading;
}

- ( void )tableViewShouldReload: ( TableViewRefresh * )view
{
    ( void )view;
    
	[ self reloadTableViewDataSource ];
	[ self performSelector: @selector( doneLoadingTableViewData ) withObject: nil afterDelay: 0 ];
}

@end
