//
//  HSDropMenuView.m
//  HousekeepingServer
//
//  Created by Jacob on 15/9/22.
//  Copyright (c) 2015年 com.jacob. All rights reserved.
//

#import "HSDropMenuView.h"
#define Main_Screen_Height [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width [[UIScreen mainScreen] bounds].size.width
#define KBgMaxHeight  Main_Screen_Height
#define KTableViewMaxHeight 300

@implementation HSIndexPath

+ (instancetype)twIndexPathWithColumn:(NSInteger )column row:(NSInteger )row{
    HSIndexPath *indexPath = [[self alloc]initWithColumn:column row:row];
    return indexPath;
}

- (instancetype)initWithColumn:(NSInteger )column row:(NSInteger )row{
    
    if (self = [super init]) {
        self.column = column;
        self.row =row;
    }
    
    return self;
}


@end

static NSString *cellIdent = @"cellIdent";
@interface HSDropMenuView ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger _currSelectColumn;
    CGFloat _rightHeight;
    BOOL _isRightOpen;
    BOOL _isLeftOpen;
}
@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) UITableView *rightTableView;
@property (nonatomic,strong) UIButton *bgButton; //背景按钮

@end

@implementation HSDropMenuView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
//        [self _setButton];
        [self _setSubViews];
    }
    return self;
}
///**
// *  设置背景按钮
// */
//- (void)_setButton{
//    UIView *bottomShadow = [[UIView alloc]
//                            initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, Main_Screen_Width, 0.5)];
//    bottomShadow.backgroundColor = [UIColor colorWithRed:0.468 green:0.485 blue:0.465 alpha:1.000];
//    [self addSubview:bottomShadow];
//}
/**
 *  初始化
 */
- (void)_initialize{
    _currSelectColumn = 0;
    _isLeftOpen = NO;
    _isRightOpen = NO;
}

/**
 *  添加子控件
 */
- (void)_setSubViews{
    
    [self addSubview:self.bgButton];
    [self.bgButton addSubview:self.leftTableView];
    [self.bgButton addSubview:self.rightTableView];
    
}


#pragma mark -- public fun --
- (void)reloadLeftTableView{
    
    [self.leftTableView reloadData];
}

- (void)reloadRightTableView;
{
    
    [self.rightTableView reloadData];
}

#pragma mark -- getter --
- (UITableView *)leftTableView{
    
    if (!_leftTableView) {
        
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        [_leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdent];
        _leftTableView.frame = CGRectMake(0, 0, self.bgButton.frame.size.width/3.0, 0);
        _leftTableView.tableFooterView = [[UIView alloc]init];
    }
    
    return _leftTableView;
}
- (UITableView *)rightTableView{
    
    if (!_rightTableView) {
        
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        [_rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdent];
        _rightTableView.frame = CGRectMake(0, 0 , self.bgButton.frame.size.width, 0);
        
        
    }
    
    return _rightTableView;
}
- (UIButton *)bgButton{
    
    if (!_bgButton) {
        
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgButton.backgroundColor = [UIColor clearColor];
        _bgButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        [_bgButton addTarget:self action:@selector(bgAction:) forControlEvents:UIControlEventTouchUpInside];
        _bgButton.clipsToBounds = YES;
        
    }
    
    return _bgButton;
}

#pragma mark -- tableViews Change -
- (void)_hiddenLeftTableViews{
    
    self.leftTableView.frame = CGRectMake(self.leftTableView.frame.origin.x, self.leftTableView.frame.origin.y, self.leftTableView.frame.size.width, 0);
    
}
- (void)_showLeftTableViews{
    
    self.leftTableView.frame = CGRectMake(self.leftTableView.frame.origin.x, self.leftTableView.frame.origin.y, self.leftTableView.frame.size.width, KTableViewMaxHeight);
}

- (void)_showRightTableView{
    
    CGFloat height = MIN(_rightHeight, KTableViewMaxHeight);
    
    self.rightTableView.frame = CGRectMake(self.rightTableView.frame.origin.x, self.rightTableView.frame.origin.y, self.rightTableView.frame.size.width, height);
}

- (void)_HiddenRightTableView{
    self.rightTableView.frame = CGRectMake(self.rightTableView.frame.origin.x, self.rightTableView.frame.origin.y, self.rightTableView.frame.size.width, 0);
}
- (void)_changeTopButton:(NSString *)string{
    
    
    if (_currSelectColumn == 0) {
        
        [self.leftBtn setTitle:string forState:UIControlStateNormal];
    }
    if (_currSelectColumn == 1) {
        
        [self.rightBtn setTitle:string forState:UIControlStateNormal];
    }
    
}

#pragma mark -- Action ----
- (void)buttonAction:(UIButton *)sender{
    if (self.leftBtn == sender) {
        if (_isLeftOpen) {
            _isLeftOpen = !_isLeftOpen;
            [self bgAction:nil];
            return ;
        }
        _currSelectColumn = 0;
        _isLeftOpen = YES;
        _isRightOpen = NO;
        [self _HiddenRightTableView];
        
    }
    if (self.rightBtn == sender) {
        
        if (_isRightOpen) {
            _isRightOpen = !_isRightOpen;
            [self bgAction:nil];
            return ;
        }
        
        _currSelectColumn = 1;
        _isRightOpen = YES;
        _isLeftOpen = NO;
        [self _hiddenLeftTableViews];
        
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, Main_Screen_Width, Main_Screen_Height);
    self.bgButton.frame = CGRectMake(self.bgButton.frame.origin.x, self.bgButton.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.bgButton.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
        
        if (_currSelectColumn == 0) {
            [self _showLeftTableViews];
        }
        if (_currSelectColumn == 1) {
            
            [self _showRightTableView];
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)bgAction:(UIButton *)sender{
    
    _isRightOpen = NO;
    _isLeftOpen = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        
        self.bgButton.backgroundColor = [UIColor clearColor];
        [self _hiddenLeftTableViews];
        [self _HiddenRightTableView];
        
        
    } completion:^(BOOL finished) {
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, Main_Screen_Width, 0);
        self.bgButton.frame = CGRectMake(self.bgButton.frame.origin.x, self.bgButton.frame.origin.y, self.bounds.size.width, 0);
        
        
        
    }];
    
}

#pragma mark -- DataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    HSIndexPath *twIndexPath =[self _getTwIndexPathForNumWithtableView:tableView];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dropMenuView:numberWithIndexPath:)]) {
        
        NSInteger count =  [self.dataSource dropMenuView:self numberWithIndexPath:twIndexPath];
        if (twIndexPath.column == 1) {
            _rightHeight = count * 44.0;
        }
        return count;
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HSIndexPath *twIndexPath = [self _getTwIndexPathForCellWithTableView:tableView indexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor =  [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.004 alpha:1.000];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    //    [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dropMenuView:titleWithIndexPath:)]) {
        
        cell.textLabel.text =  [self.dataSource dropMenuView:self titleWithIndexPath:twIndexPath];
    }else{
        
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    }
    
    
    return cell;
    
}


#pragma mark - tableView delegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self _changeTopButton:cell.textLabel.text ];
    
    
    if (self.leftTableView == tableView) {
        [self bgAction:nil];
    }

    
    if (self.rightTableView == tableView) {
        [self bgAction:nil];
    }
    
    
}



- (HSIndexPath *)_getTwIndexPathForNumWithtableView:(UITableView *)tableView{
    
    
    if (tableView == self.leftTableView) {
        
        return  [HSIndexPath twIndexPathWithColumn:_currSelectColumn row:HSNoFound];
        
    }
    
        
    if (tableView == self.rightTableView) {
        
        return [HSIndexPath twIndexPathWithColumn:1 row:HSNoFound];
    }
    
    
    return  0;
}

- (HSIndexPath *)_getTwIndexPathForCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == self.leftTableView) {
        
        return  [HSIndexPath twIndexPathWithColumn:0 ];
        
    }
    
    if (tableView == self.rightTableView) {
        
        return [HSIndexPath twIndexPathWithColumn:1 ];
    }
    
    
    return  [HSIndexPath twIndexPathWithColumn:0];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
}



@end
