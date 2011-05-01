/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      TableViewRefresh.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import <QuartzCore/QuartzCore.h>

typedef enum
{
	TableViewRefreshStatePulling = 0x00,
	TableViewRefreshStateNormal  = 0x01,
	TableViewRefreshStateLoading = 0x02
}
TableViewRefreshState;

FOUNDATION_EXPORT NSString * TableViewHeaderArrowTypeWhite;
FOUNDATION_EXPORT NSString * TableViewHeaderArrowTypeBlack;
FOUNDATION_EXPORT NSString * TableViewHeaderArrowTypeBlue;

@class TableViewRefresh;

@protocol TableViewRefreshDelegate

@required
    
    - ( BOOL )tableViewIsLoading: ( TableViewRefresh * )view;
    - ( void )tableViewShouldReload: ( TableViewRefresh * )view;
    
@optional

@end

/*!
 * @class       TableViewRefresh
 * @abstract    ...
 */
@interface TableViewRefresh: UIView
{
@protected
    
    TableViewRefreshState     state;
    UILabel                 * lastUpdatedLabel;
    UILabel                 * statusLabel;
    CALayer                 * arrowImage;
    UIActivityIndicatorView * activityView;
    NSDate                  * date;
    NSDateFormatter         * dateFormat;
    id                        delegate;
    
@private
    
    id r1;
    id r2;
}
@property( readonly          ) UILabel                       * lastUpdatedLabel;
@property( readonly          ) UILabel                       * statusLabel;
@property( readonly          ) UIActivityIndicatorView       * activityView;
@property( assign, readwrite ) id < TableViewRefreshDelegate > delegate;

- ( void )setArrowType: ( NSString * )type;
- ( void )setDateFormat: ( NSDateFormatter * )format;
- ( void )setState: ( TableViewRefreshState )aState;
- ( void )scrollViewDidScroll: ( UIScrollView * )scrollView;
- ( void )scrollViewDidEndDragging: ( UIScrollView * )scrollView;
- ( void )scrollViewDidFinishLoading: ( UIScrollView * )scrollView;

@end
