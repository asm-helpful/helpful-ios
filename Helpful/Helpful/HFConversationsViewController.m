//
//  HFConversationsViewController.m
//  Helpful
//
//  Created by Matthias Plappert on 28/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFConversationsViewController.h"
#import "HFMessageCellTableViewCell.h"

#import "HFAccount.h"
#import "HFConversation.h"
#import "HFMessage.h"

#import "HFMessagesViewController.h"

static NSString * messageCellIdentifier = @"MessageCell";

@interface HFConversationsViewController ()

@property (nonatomic, copy, readwrite) NSArray *conversations;

- (void)hf_fetchConversations;

@end

@implementation HFConversationsViewController

- (id)initWithAccount:(HFAccount *)account contentType:(HFConversationsViewControllerContentType)contentType {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        _account = account;
        _contentType = contentType;
        
        NSString *title;
        switch (contentType) {
            case HFConversationsViewControllerContentTypeArchive:
                title = NSLocalizedString(@"Archive", nil);
                break;
                
            case HFConversationsViewControllerContentTypeInbox:
                title = NSLocalizedString(@"Inbox", nil);
                break;
        }
        NSAssert(title, @"Invalid title");
        self.title = title;
    }
    return self;
}

#pragma mark - Accessors

- (void)setConversations:(NSArray *)conversations {
    if (![_conversations isEqualToArray:conversations]) {
        _conversations = [conversations copy];
        [self.tableView reloadData];
    }
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"HFMessageCellTableViewCell" bundle:nil] forCellReuseIdentifier:messageCellIdentifier];

    if (!self.conversations) {
        [self hf_fetchConversations];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFMessageCellTableViewCell *cell = (HFMessageCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:messageCellIdentifier forIndexPath:indexPath];
    
    HFConversation *conversation = self.conversations[indexPath.row];
    cell.conversation = conversation;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HFMessagesViewController *controller = [[HFMessagesViewController alloc] initWithConversations:self.conversations];
    controller.currentConversationIndex = indexPath.row;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Private Methods

- (void)hf_fetchConversations {
    // Fetch all accounts.
    RKObjectRequestOperation *operation;
    switch (self.contentType) {
        case HFConversationsViewControllerContentTypeArchive:
            operation = [HFConversation fetchArchivedConversationsRequestOperationForAccount:self.account];
            break;
            
        case HFConversationsViewControllerContentTypeInbox:
            operation = [HFConversation fetchInboxConversationsRequestOperationForAccount:self.account];
            break;
    }
    NSAssert(operation, @"Undefined request operation");
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.conversations = [mappingResult array];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // TODO: handle this!
        NSLog(@"could not fetch conversations: %@", error);
    }];
    [operation start];
}

@end
