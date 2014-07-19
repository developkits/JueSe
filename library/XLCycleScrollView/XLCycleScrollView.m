//
//  XLCycleScrollView.m
//  CycleScrollViewDemo
//
//  Created by xie liang on 9/14/12.
//  Copyright (c) 2012 xie liang. All rights reserved.
//

#import "XLCycleScrollView.h"

@implementation XLCycleScrollView

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize currentPage = _curPage;
@synthesize datasource = _datasource;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_scrollView release];
    [_pageControl release];
    [_curViews release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor=[UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(frame.size.width*3 , frame.size.height);
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces=NO;
       
        [self addSubview:_scrollView];
        
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 80;
        rect.size.height = 30;
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        _pageControl.userInteractionEnabled = NO;
        if([_pageControl respondsToSelector:@selector(setPageIndicatorTintColor:)])
        {
            [_pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
            _pageControl.currentPageIndicatorTintColor=MAIN_COLOR;
        }
        
        [self addSubview:_pageControl];
        
        _curPage = 0;
        isBig=NO;
    }
    return self;
}

- (void)setDataource:(id<XLCycleScrollViewDatasource>)datasource
{
    _datasource = datasource;
    [self reloadData];
}

- (void)reloadData
{
    _totalPages = [_datasource numberOfPages];
    if (_totalPages == 0) {
        return;
    }
    _pageControl.numberOfPages = _totalPages;
    [self loadData];
}

- (void)loadData
{
    
    _pageControl.currentPage = _curPage;
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    for (int i = 0; i < 3; i++) {
        UIView *v = [_curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        singleTap.numberOfTapsRequired=2;
        singleTap.numberOfTouchesRequired=1;
        [v addGestureRecognizer:singleTap];
        [singleTap release];
        //v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        v.frame=CGRectMake(v.frame.origin.x+self.bounds.size.width*i,v.frame.origin.y,v.frame.size.width,v.frame.size.height);
        [_scrollView addSubview:v];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

- (void)getDisplayImagesWithCurpage:(int)page {
    
    int pre = [self validPageValue:_curPage-1];
    int last = [self validPageValue:_curPage+1];
    
    if (!_curViews) {
        _curViews = [[NSMutableArray alloc] init];
    }
    
    [_curViews removeAllObjects];
    
    [_curViews addObject:[_datasource pageAtIndex:pre]];
    [_curViews addObject:[_datasource pageAtIndex:page]];
    [_curViews addObject:[_datasource pageAtIndex:last]];
}

- (int)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_curPage];
#if 1
        UIScrollView* tapView=(UIScrollView*)[tap view];
        CGPoint point =[tap locationInView:[tap view]];
        CGFloat currentWidth=tapView.contentSize.width;
        CGFloat currentHeight=tapView.contentSize.height;
        CGFloat destWidth;
        CGFloat destHeight;
        CGFloat xPositionPersent;
        CGFloat yPositionPersent;
        CGFloat tempContentOffSetX;
        CGFloat tempContentOffSetY;
        CGFloat contentOffSetX;
        CGFloat contentOffSetY;
        if(isBig==NO)
        {
             destWidth=currentWidth*1.5;
             destHeight=currentHeight*1.5;
             xPositionPersent=point.x/currentWidth;
             yPositionPersent=point.y/currentHeight;
             tempContentOffSetX=xPositionPersent*destWidth-currentWidth/2;
             tempContentOffSetY=yPositionPersent*destHeight-currentHeight/2;
             contentOffSetX= (tempContentOffSetX<0?0:tempContentOffSetX)>destWidth/3.0?destWidth/3.0:(tempContentOffSetX<0?0:tempContentOffSetX);
             contentOffSetY=(tempContentOffSetY<0?0:tempContentOffSetY)>destHeight/3.0?destHeight/3.0:(tempContentOffSetY<0?0:tempContentOffSetY);
            isBig=YES;
        }
        else
        {
             destWidth=currentWidth*2/3.0;
             destHeight=currentHeight*2/3.0;
            //CGFloat xPositionPersent=point.x/currentWidth;
            //CGFloat yPositionPersent=point.y/currentHeight;
            //CGFloat tempContentOffSetX=xPositionPersent*destWidth-currentWidth/2;
            //CGFloat tempContentOffSetY=yPositionPersent*destHeight-currentHeight/2;
             contentOffSetX= 0;
             contentOffSetY=0;
            isBig=NO;

        }
      //  tapView.contentSize=CGSizeMake(destWidth, destHeight);
      //  tapView.contentOffset=CGPointMake(contentOffSetX, contentOffSetY);
        
        UIView * sonView= [tapView viewWithTag:99];
        [UIView animateWithDuration:0.25 animations:^{
            tapView.contentSize=CGSizeMake(destWidth, destHeight);
            tapView.contentOffset=CGPointMake(contentOffSetX, contentOffSetY);
            sonView.frame=CGRectMake(0, 0, tapView.contentSize.width, tapView.contentSize.height);}];
               
#endif 
        
        
    }
    
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _curPage) {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
            [singleTap release];
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        _curPage = [self validPageValue:_curPage+1];
        [self loadData];
    }
    
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage-1];
        [self loadData];
    }
    isBig=NO;

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    
    NSLog(@"currentPage:%d",self.currentPage);
    
}

@end
