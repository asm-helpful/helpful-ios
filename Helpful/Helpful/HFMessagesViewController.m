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

@property (nonatomic, strong, readonly) NSArray *conversations;

@property (nonatomic, copy, readwrite) NSArray *conversationItems;
@property (nonatomic, weak) UIBarButtonItem* upBarButtonItem;
@property (nonatomic, weak) UIBarButtonItem* downBarButtonItem;

@end

static NSString * messageCellIdentifier = @"MessageCell";

@implementation HFMessagesViewController

- (id)initWithConversations:(NSArray *)conversations {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        _conversations = conversations;
        
        _currentConversationIndex = NSNotFound;
    }
    return self;
}

#pragma mark - Accessors

-(void)setConversationItems:(NSArray *)conversationItems {
    if (![_conversationItems isEqualToArray:conversationItems]) {

        //Sort ascending on created field
        //Explicit copy not needed because sorting this way implies a copy.
        _conversationItems = [conversationItems sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:YES]]];

        __weak HFMessagesViewController *weakSelf = self;
        [UIView transitionWithView: self.tableView
                          duration: 0.35f
                           options: UIViewAnimationOptionTransitionCrossDissolve
                        animations: ^(void)
         {
             [weakSelf.tableView reloadData];
         } completion:^(BOOL finished) {}];
    }
    
    if (conversationItems.count > 0) {
        BOOL enableUp = YES;
        BOOL enableDown = YES;
        if (self.currentConversationIndex <= 0) {
            enableUp = NO;
        }
        if (self.currentConversationIndex >= self.conversations.count -1) {
            enableDown = NO;
        }
        
        self.downBarButtonItem.enabled = enableDown;
        self.upBarButtonItem.enabled = enableUp;    }
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
    
    NIKFontAwesomeIconFactory *iconFactory = [NIKFontAwesomeIconFactory barButtonItemIconFactory];
    iconFactory.padded = NO;
    iconFactory.size = 44.0;
    
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *downImage = [iconFactory createImageForIcon:NIKFontAwesomeIconAngleDown];
    downButton.bounds = CGRectMake(0.0, 0.0, downImage.size.width, downImage.size.height);
    [downButton setImage:downImage forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(nextMessage:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *upImage = [iconFactory createImageForIcon:NIKFontAwesomeIconAngleUp];
    upButton.bounds = CGRectMake(0.0, 0.0, upImage.size.width, upImage.size.height);
    [upButton setImage:upImage forState:UIControlStateNormal];
    [upButton addTarget:self action:@selector(previousMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *downBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:downButton];
    UIBarButtonItem *upBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:upButton];
    
    self.downBarButtonItem = downBarButtonItem;
    self.upBarButtonItem = upBarButtonItem;

    NSArray *rightBarButtonItems = @[downBarButtonItem, upBarButtonItem];
    

    self.navigationItem.rightBarButtonItems = rightBarButtonItems;
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *headerCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    headerCell.textLabel.text = [self.conversations[self.currentConversationIndex] subject];
    headerCell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:18.0];
    
    
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@, ", [self.conversations[self.currentConversationIndex] creatorPerson].name] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans-Semibold" size:12.0]}];
    [detailText appendAttributedString:[[NSAttributedString alloc] initWithString:[self.conversations[self.currentConversationIndex] creatorPerson].email attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12.0]}]];
    
    headerCell.detailTextLabel.attributedText = detailText;
    headerCell.backgroundColor = [UIColor separatorColor];
    
    headerCell.frame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, [self tableView:tableView heightForHeaderInSection:section]);
    
    return headerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 76.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.currentConversationIndex >= self.conversations.count || self.currentConversationIndex < 0) {
        return 0;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentConversationIndex >= self.conversations.count || self.currentConversationIndex < 0) {
        return 0;
    }
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

- (void)setCurrentConversationIndex:(NSInteger)newConversationIndex {
    self.upBarButtonItem.enabled = NO;
    self.downBarButtonItem.enabled = NO;
    
    if (self.conversations.count == 0) {
        _currentConversationIndex = NSNotFound;
    } else if (newConversationIndex < 0) {
        _currentConversationIndex = 0;
    } else if (newConversationIndex >= self.conversations.count) {
        _currentConversationIndex = self.conversations.count -1;
    } else {
        _currentConversationIndex = newConversationIndex;
    }
    
    self.conversationItems = nil;
    
    // Fetch all accounts.
    RKObjectRequestOperation *operation = [HFMessage fetchMessageRequestOperationForConversation:self.conversations[self.currentConversationIndex]];
    NSAssert(operation, @"Undefined request operation");
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSMutableArray *data = [NSMutableArray array];
        [data addObjectsFromArray:[mappingResult array]];
        [data addObjectsFromArray:[self.conversations[self.currentConversationIndex] tagEvents]];
        [data addObjectsFromArray:[self.conversations[self.currentConversationIndex] assignmentEvents]];
        self.conversationItems = data;
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // TODO: handle this!
        NSLog(@"could not fetch conversations: %@", error);
    }];
    [operation start];
}

-(void)nextMessage:(id)sender {
    self.currentConversationIndex++;
}

-(void)previousMessage:(id)sender {
    self.currentConversationIndex--;
}

@end
