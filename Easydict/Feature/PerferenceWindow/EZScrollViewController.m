//
//  EZScrollViewController.m
//  Easydict
//
//  Created by tisfeng on 2023/1/11.
//  Copyright © 2023 izual. All rights reserved.
//

#import "EZScrollViewController.h"

static CGFloat const kMargin = 0;

@interface EZScrollViewController ()

@end

@implementation EZScrollViewController

- (instancetype)init {
    if (self = [super init]) {
        [self updateMaxViewSize];

        self.verticalPadding = 15;
        self.horizontalPadding = 8;

        self.topMargin = 30;
        self.bottomMargin = 30;
        self.leftMargin = 50;
        self.rightMargin = 50;
    }
    return self;
}

- (void)loadView {
    CGRect frame = CGRectMake(0, 0, self.maxViewSize.width, self.maxViewSize.height);
    self.view = [[NSView alloc] initWithFrame:frame];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _setupUI];
}


#pragma mark - Setter

- (void)setMaxViewWidthRatio:(CGFloat)maxViewWidthRatio {
    _maxViewWidthRatio = maxViewWidthRatio;
    [self updateMaxViewSize];
}

- (void)setMaxViewHeightRatio:(CGFloat)maxViewHeightRatio {
    _maxViewHeightRatio = maxViewHeightRatio;
    [self updateMaxViewSize];
}

#pragma mark - Public

- (void)updateViewSize {
    [self.view layoutSubtreeIfNeeded];

    CGSize viewSize = self.scrollView.documentView.size;
    if (viewSize.height > self.maxViewSize.height) {
        viewSize.height = self.maxViewSize.height;
    }
    self.view.size = CGSizeMake(viewSize.width + 2 * kMargin, viewSize.height + 2 * kMargin);
    
    // scroll to top
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat scrollDistance = self.scrollView.documentView.height - self.view.height;
        [self.scrollView.contentView scrollToPoint:NSMakePoint(0, scrollDistance)];
        [self.scrollView reflectScrolledClipView:self.scrollView.contentView];
    });
}

#pragma mark -

- (void)updateMaxViewSize {
    [self updateMaxViewWidthRatio:self.maxViewWidthRatio heightRatio:self.maxViewHeightRatio];
}

- (void)updateMaxViewWidthRatio:(CGFloat)maxViewWidthRatio heightRatio:(CGFloat)maxViewHeightRatio {
    CGSize visibleFrameSize = NSScreen.mainScreen.visibleFrame.size;
    maxViewWidthRatio = maxViewWidthRatio ?: 0.8;
    maxViewHeightRatio = maxViewHeightRatio ?: 0.7;
    
    self.maxViewSize = CGSizeMake(visibleFrameSize.width * maxViewWidthRatio, visibleFrameSize.height * maxViewHeightRatio);
}

- (void)_setupUI {
    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.hasVerticalScroller = YES;
    scrollView.hasHorizontalScroller = NO;
    scrollView.contentView.backgroundColor = NSColor.ez_resultViewBgColor;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];

    NSView *contentView = [[NSView alloc] initWithFrame:self.view.bounds];
    scrollView.documentView = contentView;
    contentView.wantsLayer = YES;
    contentView.layer.backgroundColor = NSColor.ez_resultViewBgColor.CGColor;
    self.contentView = contentView;
}

- (void)updateViewConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(kMargin);
    }];

    if (self.topmostView && self.bottommostView && self.leftmostView && self.rightmostView) {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topmostView).offset(-self.topMargin);
            make.bottom.equalTo(self.bottommostView).offset(self.bottomMargin);
            make.left.equalTo(self.leftmostView).offset(-self.leftMargin);
            make.right.equalTo(self.rightmostView).offset(self.rightMargin);
        }];
    }

    [super updateViewConstraints];
}

@end
