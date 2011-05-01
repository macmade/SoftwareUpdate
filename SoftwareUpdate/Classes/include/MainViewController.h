/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      MainViewController.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

@class ApplicationDelegate, UpdateFeed, TableViewRefresh;

#import "TableViewRefresh.h"

/*!
 * @class       MainViewController
 * @abstract    ...
 */
@interface MainViewController: UIViewController < ADBannerViewDelegate, UIAlertViewDelegate, TableViewRefreshDelegate >
{
@protected
    
    BOOL                  adViewVisible;
    BOOL                  reloading;
    ApplicationDelegate * appDelegate;
    UpdateFeed          * feed;
    UITableView         * tableView;
    ADBannerView        * adView;
    NSString            * feedURL;
    TableViewRefresh    * refreshView;
    
@private
    
    id r1;
    id r2;
}

@property( nonatomic, retain ) IBOutlet UITableView  * tableView;

- ( void )refresh;
- ( void )hideIAd;

@end
