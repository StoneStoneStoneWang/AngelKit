//
//  AWMAddressSelectedViewController.m
//  ZFragment
//
//  Created by three stone 王 on 2020/3/21.
//  Copyright © 2020 three stone 王. All rights reserved.
//

#import "AWMAddressSelectedViewController.h"

@import Masonry;
@import SToolsKit;
@import JXTAlertManager;

@interface AWMAddressSelectedTableViewCell : AWMBaseTableViewCell

@property (nonatomic ,strong) AWMAddressBean *address;

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UILabel *subTitleLabel;

@property (nonatomic ,strong) UILabel *phoneLabel;
@end
@implementation AWMAddressSelectedTableViewCell

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [UILabel new];
        
        _titleLabel.font = [UIFont systemFontOfSize:15];
        
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        
        _titleLabel.textColor = [UIColor s_transformToColorByHexColorStr:@"#333333"];
        
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    
    if (!_subTitleLabel) {
        
        _subTitleLabel = [UILabel new];
        
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
        
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        
        _subTitleLabel.textColor = [UIColor s_transformToColorByHexColorStr:@"#666666"];
    }
    return _subTitleLabel;
}

- (UILabel *)phoneLabel {
    
    if (!_phoneLabel) {
        
        _phoneLabel = [UILabel new];
        
        _phoneLabel.font = [UIFont systemFontOfSize:15];
        
        _phoneLabel.textAlignment = NSTextAlignmentLeft;
        
        _phoneLabel.textColor = [UIColor s_transformToColorByHexColorStr:@"#333333"];
    }
    return _phoneLabel;
}
- (void)commitInit {
    [super commitInit];
    
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.subTitleLabel];
    
    [self.contentView addSubview:self.phoneLabel];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.bottomLineType = AWMBottomLineTypeNormal;
    
}

- (void)setAddress:(AWMAddressBean *)address {
    
    self.titleLabel.text = address.name;
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.phoneLabel.text = address.phone;
    
    if (address.regionne && [address.regionne isEqualToString:@""]) {
        
        self.subTitleLabel.text = [NSString stringWithFormat:@"%@%@%@",address.plclne,address.cityne,address.addr];
    } else {
        
        self.subTitleLabel.text = [NSString stringWithFormat:@"%@%@%@%@",address.plclne,address.cityne,address.regionne,address.addr];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        
        make.top.mas_equalTo(15);
        
        make.width.mas_equalTo(80);
        
        make.height.mas_equalTo(25);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(15);
        
        make.width.mas_equalTo(100);
        
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        
        make.height.mas_equalTo(25);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        
        make.right.mas_equalTo(-15);
        
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        
        make.height.mas_equalTo(20);
    }];
}
@end

@interface AWMAddressSelectedViewController ()

@property (nonatomic ,strong) AWMAddressBridge *bridge;

@property (nonatomic ,strong) UIButton *completeItem;

@property (nonatomic ,copy) AWMAddressSelectedBlock addressBlock;

@end

@implementation AWMAddressSelectedViewController

+ (instancetype)createAddressSelectedWithBlock:(AWMAddressSelectedBlock) addressBlock {
    
    return [[AWMAddressSelectedViewController alloc] initWithBlock:addressBlock];
}
- (instancetype)initWithBlock:(AWMAddressSelectedBlock) addressBlock {
    
    if (self = [super init]) {
        
        self.addressBlock = addressBlock;
    }
    return self;
}

- (UIButton *)completeItem {
    
    if (!_completeItem) {
        
        _completeItem = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _completeItem.tag = 301;
        
        [_completeItem setBackgroundImage:[UIImage s_transformFromHexColor:@AWMColor] forState:UIControlStateNormal];
        
        [_completeItem setBackgroundImage:[UIImage s_transformFromAlphaHexColor:[NSString stringWithFormat:@"%@80",@AWMColor]] forState:UIControlStateHighlighted];
        
        [_completeItem setTitle:@"+ 新增地址" forState: UIControlStateNormal];
        
        [_completeItem setTitle:@"+ 新增地址" forState: UIControlStateHighlighted];
        
        [_completeItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_completeItem setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        _completeItem.layer.cornerRadius = 24;
        
        _completeItem.layer.masksToBounds = true;
        
        _completeItem.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _completeItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
#if AWMPROFILEALPHA
    
    [self.navigationController setNavigationBarHidden:false];
#endif
}
- (void)addOwnSubViews {
    [super addOwnSubViews];
    
    [self.view addSubview:self.completeItem];
    
}
- (void)configOwnSubViews {
    
    [self.tableView registerClass:[AWMAddressSelectedTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.mj_footer.hidden = true;
    
    self.tableView.mj_insetT = 1;
}

- (UITableViewCell *)configTableViewCell:(id)data forIndexPath:(NSIndexPath *)ip {
    
    AWMAddressSelectedTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[AWMAddressSelectedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.address = data;
    
    return cell;
}
- (void)tableViewSelectData:(id)data forIndexPath:(NSIndexPath *)ip  {
    
    self.addressBlock(AWMAddressActionTypeEdit, data, ip,self);
}

- (CGFloat)caculateForCell:(id)data forIndexPath:(NSIndexPath *)ip {
    
    CGFloat height = 0;
    
    height += 15;
    
    height += 25;
    
    height += 5;
    
    height += 20;
    
    height += 15;
    
    return height;
}

- (void)configViewModel {
    
    self.bridge = [AWMAddressBridge new];
    // -1 失败  0 成功  1空
    
    __weak typeof(self) weakSelf = self;
    
    [self.bridge createAddress:self status:^(NSInteger status) {
        
        if (status == -1) {
            
            
        } else if (status == 0) {
            
            [weakSelf.view addSubview:weakSelf.completeItem];
            
            [weakSelf.completeItem mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(20);
                
                make.right.bottom.mas_equalTo(-20);
                
                make.height.mas_equalTo(48);
            }];
        } else if (status == 1) {
            
            UIView *emptyView = nil;
            
            for (UIView *aView in weakSelf.view.subviews) {
                
                if ([aView isKindOfClass:NSClassFromString(@"ZEmptyView")]) {
                    
                    emptyView = (UIView *)NSClassFromString(@"ZEmptyView");
                    
                    break;
                }
            }
            
            if (emptyView) {
                
                [weakSelf.view insertSubview:weakSelf.completeItem aboveSubview:emptyView];
            } else {
                
                [weakSelf.view addSubview:weakSelf.completeItem];
            }
            
            [weakSelf.completeItem mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(20);
                
                make.right.bottom.mas_equalTo(-20);
                
                make.height.mas_equalTo(48);
            }];
        }
    } addressAction:^(enum AWMAddressActionType actionType, NSIndexPath * _Nullable ip, AWMAddressBean * _Nullable addressBean) {
        
        switch (actionType) {
            case AWMAddressActionTypeDelete:
            {
                
                [weakSelf alertShow:addressBean andIp:ip];
            }
                break;
                
            default:
                weakSelf.addressBlock(actionType, addressBean, ip ,weakSelf);
                break;
        }
    }];
    
    [self.tableView.mj_header beginRefreshing];
}
- (void)alertShow:(AWMAddressBean *)address andIp:(NSIndexPath *)ip {
    
    __weak typeof(self) weakSelf = self;
    
    [self jxt_showAlertWithTitle:@"点击确定删除地址" message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        
        alertMaker
        .addActionCancelTitle(@"取消")
        .addActionDefaultTitle(@"确定");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        
        if ([action.title isEqualToString:@"确定"]) {
            
            [weakSelf.bridge removeAddress:address ip:ip];
        }
    }];
}
- (void)updateAddress:(AWMAddressBean *)addressBean andIp:(NSIndexPath *)ip {
    
    [self.bridge updateAddress:addressBean ip:ip];
}

- (void)insertAddress:(AWMAddressBean *)addressBean {
    
    [self.bridge insertAddress:addressBean addressAction:^(enum AWMAddressActionType actionType, NSIndexPath * _Nullable ip, AWMAddressBean * _Nullable address) {
        
        
    }];
}
- (void)onReloadItemClick {
    [super onReloadItemClick];
    
    [self.tableView.mj_header beginRefreshing];
}

- (BOOL)canPanResponse { return true; }

- (void)configNaviItem {
    
    self.title = @"选择地址";
}

- (BOOL)prefersStatusBarHidden {
    
    return false;
}

@end
