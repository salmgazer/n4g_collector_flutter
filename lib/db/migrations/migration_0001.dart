final migration_0001 = [
  '''
    CREATE TABLE IF NOT EXISTS `withdrawals` (
      `id` varchar(255),
      `reason` text not null,
      `amount` decimal not null,
      `supplierId` varchar(255) not null,
      `collectorId` varchar(255) not null,
      `sacs` decimal not null,
      `productId` varchar(255) not null,
      `createdAt` bigint,
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
    CREATE TABLE IF NOT EXISTS `walletTopUps` (
      `id` varchar(255),
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
      `id` varchar(255),
      `price` decimal not null,
      `userId` varchar(255) not null,
      `communityId` varchar(255) not null,
      `productId` not null,
      `createdAt` bigint not null,
      `updatedAt` bigint not null,
      foreign key(`userId`) references `users`(`id`),
      foreign key(`productId`) references `products`(`id`),
      foreign key(`communityId`) references `communities`(`id`),
      primary key (`id`)
    )
  '''
];