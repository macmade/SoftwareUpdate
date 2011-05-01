/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      UpdateFeed.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

/*!
 * @class       UpdateFeed
 * @abstract    ...
 */
@interface UpdateFeed: NSObject < NSXMLParserDelegate >
{
@protected
    
    NSString             * feedUrl;
    NSMutableArray       * updates;
    NSMutableDictionary  * item;
    NSXMLParser          * parser;
    NSMutableString      * text;
    NSMutableString      * link;
    BOOL                   inItem;
    BOOL                   inTitle;
    BOOL                   inLink;
    BOOL                   inDescription;
    BOOL                   dataLoaded;
    
@private
    
    id r1;
    id r2;
}

@property( readonly          ) BOOL          dataLoaded;
@property( readonly          ) NSArray     * updates;

- ( id )initWithFeedURL: ( NSString * )url;
- ( void )loadData;

@end
