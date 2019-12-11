final migration_0001 = [
  '''
    CREATE TABLE IF NOT EXISTS `withdrawals` (
      `id` integer,
      `reason` text not null,
      `amount` decimal not null,
      `supplierId` integer not null,
      `collectorId` not null,
      `sacs` decimal not null,
      `productId` int not null,
      `createdAt` datetime not null default CURRENT_TIMESTAMP,
      `updatedAt` datetime not null default CURRENT_TIMESTAMP,
      foreign key(`supplierId`) references `suppliers`(`id`),
      foreign key(`collectorId`) references `users`(`id`),
      foreign key(`productId`) references `products`(`id`),
      primary key (`id`)
    )
  ''',
  '''
    ALTER table `suppliers` add `accountBalance` float not null default 0
  ''',
  '''
    ALTER table `transactions` add `otherCost` float not null default 0
  ''',
  '''
    ALTER table `transactions` add `otherCostPurpose` text
  ''',
  '''
    ALTER table `users` add `wallet` float not null default 0
  ''',
  '''
    CREATE TABLE IF NOT EXISTS `walletTopUps` (
      `id` integer,
      `amount` decimal not null,
      `forUserId` integer not null,
      `byUserId` not null,
      `createdAt` datetime not null default CURRENT_TIMESTAMP,
      `updatedAt` datetime not null default CURRENT_TIMESTAMP,
      foreign key(`forUserId`) references `users`(`id`),
      foreign key(`byUserId`) references `users`(`id`),
      primary key (`id`)
    )
  ''',
  '''
    CREATE TABLE IF NOT EXISTS `communityProducePrices` (
      `id` integer,
      `price` decimal not null,
      `userId` integer not null,
      `communityId` not null,
      `productId` not null,
      `createdAt` datetime not null default CURRENT_TIMESTAMP,
      `updatedAt` datetime not null default CURRENT_TIMESTAMP,
      foreign key(`userId`) references `users`(`id`),
      foreign key(`productId`) references `products`(`id`),
      foreign key(`communityId`) references `communities`(`id`),
      primary key (`id`)
    )
  '''
];