/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        UpdateFeed.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "UpdateFeed.h"
#import "HostReachabilityTest.h"

@implementation UpdateFeed

@synthesize dataLoaded;
@synthesize updates;

- ( id )initWithFeedURL:( NSString * )url
{
    if( ( self = [ super init ] ) )
    {
        feedUrl = [ url copy ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ feedUrl release ];
    [ updates release ];
    [ parser  release ];
    
    [ super dealloc ];
}

- ( void )loadData
{
    HostReachabilityTest * test;
    NSAutoreleasePool    * ap;
    
    ap = [ NSAutoreleasePool new ];
    
    [ [ UIApplication sharedApplication ] setNetworkActivityIndicatorVisible: YES ];
    
    test    = [ HostReachabilityTest testWithHost: @"feeds.feedburner.com" ];
    updates = [ [ NSMutableArray arrayWithCapacity: 100 ] retain ];
    
    if( test.isReachable == YES )
    {
        parser  = [ [ NSXMLParser alloc ] initWithContentsOfURL: [ NSURL URLWithString: feedUrl ] ];
        
        [ parser setDelegate: self ];
        [ parser parse ];
    }
    else
    {
        [ [ UIApplication sharedApplication ] setNetworkActivityIndicatorVisible: NO ];
    }
    
    [ ap release ];
}

- ( void )parser: ( NSXMLParser * )xml didStartElement: ( NSString * )elementName namespaceURI: ( NSString * )namespaceURI qualifiedName: ( NSString * )qName attributes: ( NSDictionary * )attributeDict
{
    ( void )xml;
    ( void )namespaceURI;
    ( void )qName;
    ( void )attributeDict;
    
    if( [ elementName isEqualToString: @"item" ] )
    {
        inItem = YES;
    }
    else if( inItem == YES && [ elementName isEqualToString: @"title" ] )
    {
        inTitle = YES;
    }
    else if( inItem == YES && [ elementName isEqualToString: @"link" ] )
    {
        inLink = YES;
        link   = [ [ NSMutableString alloc ] initWithCapacity: 100 ];
    }
    else if( inItem == YES && [ elementName isEqualToString: @"description" ] )
    {
        inDescription = YES;
        text          = [ [ NSMutableString alloc ] initWithCapacity: 500 ];
    }
}

- ( void )parser: ( NSXMLParser * )xml didEndElement: ( NSString * )elementName namespaceURI: ( NSString * )namespaceURI qualifiedName: ( NSString * )qName
{
    ( void )xml;
    ( void )namespaceURI;
    ( void )qName;
    
    if( [ elementName isEqualToString: @"item" ] )
    {
        inItem = NO;
    }
    else if( inItem == YES && [ elementName isEqualToString: @"title" ] )
    {
        inTitle = NO;
    }
    else if( inItem == YES && [ elementName isEqualToString: @"link" ] )
    {
        [ item setObject: link forKey: @"link" ];
        [ link release ];
        
        inLink = NO;
        link   = nil;
    }
    else if( inItem == YES && [ elementName isEqualToString: @"description" ] )
    {
        [ item setObject: text forKey: @"text" ];
        [ text release ];
        
        inDescription = NO;
        text          = nil;
    }
}

- ( void )parser: ( NSXMLParser * )xml foundCDATA: ( NSData * )CDATABlock
{
    NSString * content;
    NSString * title;
    NSString * description;
    NSRange    range;
    
    ( void )xml;
    
    if( inTitle == YES )
    {
        content = [ [ NSString alloc ] initWithData: CDATABlock encoding: NSUTF8StringEncoding ];
        range   = [ content rangeOfString: @" - " ];
        
        if( range.location != NSNotFound )
        {
            title       = [ content substringToIndex:   range.location ];
            description = [ content substringFromIndex: range.location + 3 ];
            item        = [ NSMutableDictionary dictionaryWithObjectsAndKeys: title, @"title", description, @"description", nil ];
        }
        
        [ updates addObject: item ];
    }
}

- ( void )parser: ( NSXMLParser * )xml foundCharacters: ( NSString * )string
{
    ( void )xml;
    
    if( inDescription == YES )
    {
        [ text appendString: string ];
    }
    else if( inLink == YES )
    {
        [ link appendString: string ];
    }
}

- ( void )parserDidEndDocument: ( NSXMLParser * )xml
{
    ( void )xml;
    
    [ [ UIApplication sharedApplication ] setNetworkActivityIndicatorVisible: NO ];
    
    dataLoaded = YES;
}

@end
