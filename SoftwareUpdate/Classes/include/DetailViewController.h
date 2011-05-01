/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      DetailViewController.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

/*!
 * @class       DetailViewController
 * @abstract    ...
 */
@interface DetailViewController: UIViewController < UIWebViewDelegate >
{
@protected
    
    NSURL                   * url;
    UIWebView               * webView;
    UIActivityIndicatorView * progress;
    
@private
    
    id r1;
    id r2;
}

@property( nonatomic, retain ) IBOutlet UIWebView               * webView;
@property( nonatomic, retain ) IBOutlet UIActivityIndicatorView * progress;

- ( id )initWithURL: ( NSString * )theURL;

@end
