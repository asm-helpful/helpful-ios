//
//  HFMessagesViewController.m
//  Helpful
//
//  Created by Jeroen Leenarts on 01-11-14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFMessagesViewController.h"
#import "HFMessageCellTableViewCell.h"
#import "HFConversation.h"
#import "HFMessage.h"
#import "HFPerson.h"

#import "Helpful-Swift.h"
#import <NIKFontAwesomeIconFactory.h>
#import <NIKFontAwesomeIconFactory+iOS.h>

@interface HFMessagesViewController ()

@property (nonatomic, copy, readwrite) NSArray *conversationItems;

@end

static NSString * messageCellIdentifier = @"MessageCell";

@implementation HFMessagesViewController

- (id)initWithConversation:(HFConversation *)conversation {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        _conversation = conversation;
    }
    return self;
}

#pragma mark - Accessors

-(void)setConversationItems:(NSArray *)conversationItems {
    if (![_conversationItems isEqualToArray:conversationItems]) {

        //Sort ascending on created field
        //Explicit copy not needed because sorting this way implies a copy.
        _conversationItems = [conversationItems sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:YES]]];

        [self.tableView reloadData];
    }
}

#pragma mark - UIViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(27.0, 0.0, 1.0, self.tableView.bounds.size.height);
    lineView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    lineView.backgroundColor = [UIColor separatorColor];
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = [UIColor lightBlueBackground];
    backgroundView.frame = self.tableView.bounds;
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [backgroundView addSubview:lineView];
    self.tableView.backgroundView = backgroundView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HFMessageCellTableViewCell" bundle:nil] forCellReuseIdentifier:messageCellIdentifier];
    
    //TODO move to appropriate page
    NIKFontAwesomeIconFactory *iconFactory = [NIKFontAwesomeIconFactory barButtonItemIconFactory];
    iconFactory.padded = NO;
    iconFactory.size = 44.0;
//    iconFactory.edgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *downImage = [iconFactory createImageForIcon:NIKFontAwesomeIconAngleDown];
    downButton.bounds = CGRectMake(0.0, 0.0, downImage.size.width, downImage.size.height);
    [downButton setImage:downImage forState:UIControlStateNormal];

    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *upImage = [iconFactory createImageForIcon:NIKFontAwesomeIconAngleUp];
    upButton.bounds = CGRectMake(0.0, 0.0, upImage.size.width, upImage.size.height);
    [upButton setImage:upImage forState:UIControlStateNormal];

    NSArray *rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:upButton], [[UIBarButtonItem alloc]initWithCustomView:downButton]];

    
    
//    for (UIBarButtonItem *item in rightBarButtonItems) {
//        item.imageInsets = UIEdgeInsetsMake(0.0, -5.0, 0.0, -5.0);
//        item.customView.layoutMargins = UIEdgeInsetsMake(0.0, -5.0, 0.0, -5.0);
//    }
    self.navigationItem.rightBarButtonItems = rightBarButtonItems;

    
    
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Reply", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!self.conversationItems) {
        [self hf_fetchMessages];
    }
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *headerCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    headerCell.textLabel.text = self.conversation.subject;
    headerCell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:18.0];
    
    
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@, ", self.conversation.creatorPerson.name] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Semibold" size:12.0]}];
    [detailText appendAttributedString:[[NSAttributedString alloc] initWithString:self.conversation.creatorPerson.email attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12.0]}]];
    
    headerCell.detailTextLabel.attributedText = detailText;
    headerCell.backgroundColor = [UIColor separatorColor];
    
    headerCell.frame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, [self tableView:tableView heightForHeaderInSection:section]);
    
    return headerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 76.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversationItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFMessageCellTableViewCell * messageCell = (HFMessageCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:messageCellIdentifier forIndexPath:indexPath];

    id conversationItem = self.conversationItems[indexPath.row];
    
    if ([conversationItem isKindOfClass:[HFMessage class]]) {
        messageCell.message = conversationItem;
    } else if ([conversationItem isKindOfClass:[HFTagEvent class]]) {
        messageCell.tagEvent = conversationItem;
    } else if ([conversationItem isKindOfClass:[HFAssignmentEvent class]]) {
        messageCell.assignmentEvent = conversationItem;
    }

    return messageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods

- (void)hf_fetchMessages {
    // Fetch all accounts.
    RKObjectRequestOperation *operation = [HFMessage fetchMessageRequestOperationForConversation:self.conversation];
    NSAssert(operation, @"Undefined request operation");
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSMutableArray *data = [NSMutableArray array];
        [data addObjectsFromArray:[mappingResult array]];
        [data addObjectsFromArray:self.conversation.tagEvents];
        [data addObjectsFromArray:self.conversation.assignmentEvents];
        self.conversationItems = data;
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // TODO: handle this!
        NSLog(@"could not fetch conversations: %@", error);
    }];
    [operation start];
}

@end
