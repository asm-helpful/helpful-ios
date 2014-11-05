//
//  HFMessageCellTableViewCell.h
//  Helpful
//
//  Created by Jeroen Leenarts on 04-11-14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFMessageCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameMailLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *portratImage;

@end
