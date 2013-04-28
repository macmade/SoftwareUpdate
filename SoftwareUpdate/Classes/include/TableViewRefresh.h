/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina - www.xs-labs.com
 * Distributed under the Boost Software License, Version 1.0.
 * 
 * Boost Software License - Version 1.0 - August 17th, 2003
 * 
 * Permission is hereby granted, free of charge, to any person or organization
 * obtaining a copy of the software and accompanying documentation covered by
 * this license (the "Software") to use, reproduce, display, distribute,
 * execute, and transmit the Software, and to prepare derivative works of the
 * Software, and to permit third-parties to whom the Software is furnished to
 * do so, all subject to the following:
 * 
 * The copyright notices in the Software and this entire statement, including
 * the above license grant, this restriction and the following disclaimer,
 * must be included in all copies of the Software, in whole or in part, and
 * all derivative works of the Software, unless such copies or derivative
 * works are solely in the form of machine-executable object code generated by
 * a source language processor.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
 * SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
 * FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      TableViewRefresh.h
 * @copyright   (c) 2011 - Jean-David Gadina - www.xs-labs.com
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
