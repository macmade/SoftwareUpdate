/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        DetailViewController.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "DetailViewController.h"

@implementation DetailViewController

@synthesize webView;
@synthesize progress;

- ( id )initWithURL: ( NSString * )theURL
{
    if( ( self = [ self initWithNibName: @"DetailView" bundle: nil ] ) )
    {
        url = [ [ NSURL URLWithString: theURL ] retain ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ webView  release ];
    [ progress release ];
    [ url      release ];
    
    [ super dealloc ];
}

- ( void )viewDidLoad
{
    [ webView setDelegate: self ];
    [ progress startAnimating ];
    [ [ UIApplication sharedApplication ] setNetworkActivityIndicatorVisible: YES ];
    [ webView loadRequest: [ NSURLRequest requestWithURL: url ] ];
}

- ( void )webViewDidFinishLoad:( UIWebView * )theWebView
{
    ( void )theWebView;
    
    [ progress stopAnimating ];
    [ [ UIApplication sharedApplication ] setNetworkActivityIndicatorVisible: NO ];
}

@end
