final initialScript = [
  '''
  CREATE TABLE IF NOT EXISTS `app_settings` (
    `languageCode`varchar(50) not null default 'eng',
    `currencyName` varchar(100) not null default 'Ghanaian cedis',
    `lastLogInDate` bigint
  )
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `currencies` (
    `id` varchar(255) not null,
    `name` varchar(255) not null,
    `symbol` varchar(255) not null,
    `createdAt` bigint not null,
    `updatedAt` bigint not null,
    primary key (`id`)
  )
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `countries` (
    `name` varchar(255) not null,
    `code` varchar(255) not null,
    `currencyId` integer,
    `createdAt` bigint not null,
    `updatedAt` bigint not null,
    foreign key(`currencyId`) references `currencies`(`id`),
    primary key (`code`)
  )
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `regions` (
    `id` varchar(255) not null,
    `name` varchar(255) not null,
    `countryCode` string not null,
    `createdAt` bigint not null,
    `updatedAt` bigint not null,
    foreign key(`countryCode`) references `countries`(`code`),
    primary key (`id`)
  )
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `districts` (
    `id` varchar(255) not null,
    `name` varchar(255) not null,
    `regionId` varchar(255),
    `createdAt` bigint not null,
    `updatedAt` bigint not null,
    foreign key(`regionId`) references `regions`(`id`), primary key (`id`)
  )
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `communities` (
    `id` varchar(255) not null,
    `name` varchar(255) not null,
    `districtId` varchar(255),
    `createdAt` bigint not null,
    `updatedAt` bigint not null,
    foreign key(`districtId`) references `districts`(`id`),
    primary key (`id`)
  )
  ''',
  '''
  CREATE TABLE IF NOT EXISTS "organizations" (
    `id` varchar(255) not null, 
    `name` varchar(255) not null,
    `about` varchar(255),
    `createdAt` bigint not null,
    `updatedAt` bigint not null,
    `communityId` varchar(255),
    FOREIGN KEY(`communityId`) REFERENCES `communities`(`id`),
    PRIMARY KEY(`id`)
  )
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `languages` (
    `id` varchar(255) not null, 
    `name` varchar(255) not null,
    `code` varchar(50) not null,
    `createdAt` bigint not null,
    `updatedAt` bigint not null
  )
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `products` (
    `id` varchar(255) not null,
    `name` varchar(255) not null,
    `description` text,
    `createdAt` bigint not null,
    `updatedAt` bigint not null,
     primary key (`id`)
  )  
  ''',
  '''
  CREATE TABLE IF NOT EXISTS "suppliers" (
    `id` varchar(255) not null,
    `firstName` varchar(255) NOT NULL,
    `otherNames` varchar(255) NOT NULL,
    `about` varchar(255),
    `gender` text CHECK(`gender` in ('female','male')),
    `phone` varchar(255),
    `communityId` varchar(255)  NOT NULL,
    `membershipCode` varchar(255) NOT NULL,
    `createdAt` bigint not null,
    `updatedAt` bigint not null,
    `wallet` float not null default 0,
    `age` INTEGER,
    `ageRecordDate` bigint,
    `organizationId` varchar(255),
    FOREIGN KEY(`communityId`) REFERENCES `communities`(`id`),
    FOREIGN KEY(`organizationId`) REFERENCES `organizations`(`id`), PRIMARY KEY(`id`)
  )
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `transactions` (
    `id` varchar(255) not null,
    `date` datetime,
    `payment` text check (`payment` in ('unpaid', 'paid', 'partially paid')),
    `cost` float not null,
    `amountPaid` float not null default '0',
    `productId` varchar(255) not null,
    `supplierId` varchar(255) not null,
    `collectorId` varchar(255) not null,
    `currencyId` varchar(255) not null,
    `yield` float not null,
    `sacs` float not null,
    `status` text check (`status` in ('collected', 'shipped', 'delivered')) not null default 'collected',
    `createdAt` bigint not null,
    `updatedAt` bigint not null,
    foreign key(`productId`) references `products`(`id`),
    foreign key(`supplierId`) references `suppliers`(`id`),
    foreign key(`collectorId`) references `users`(`id`),
    foreign key(`currencyId`) references `currencies`(`id`),
    primary key (`id`)
  )
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `users` (
    `userId` varchar(255) not null,
    `firstName` varchar(255) not null,
    `otherNames` varchar(255),
    `phone` varchar(255) not null,
    `wallet` float not null default 0,
    `password` varchar(255),
    `status` varchar(255),
    `gender` text check (`gender` in ('male', 'female')) not null,
    `createdAt` bigint not null,
    `updatedAt` bigint not null
  )
  '''
];