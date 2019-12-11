final initialScript = [
  '''
  CREATE TABLE IF NOT EXISTS `app_settings` ( `languageCode`varchar(50) not null default 'eng', `currencyName` varchar(100) not null default 'Ghanaian cedis' )
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `currencies` (`id` integer, `name` varchar(255) not null, `symbol` varchar(255) not null, `createdAt` datetime not null default CURRENT_TIMESTAMP, `updatedAt` datetime not null default CURRENT_TIMESTAMP, primary key (`id`))
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `countries` (`id` integer, `name` varchar(255) not null, `code` varchar(255) not null, `currencyId` integer, `createdAt` datetime not null default CURRENT_TIMESTAMP, `updatedAt` datetime not null default CURRENT_TIMESTAMP, foreign key(`currencyId`) references `currencies`(`id`), primary key (`id`))
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `regions` (`id` integer, `name` varchar(255) not null, `countryId` integer not null, `createdAt` datetime not null default CURRENT_TIMESTAMP, `updatedAt` datetime not null default CURRENT_TIMESTAMP, foreign key(`countryId`) references `countries`(`id`), primary key (`id`))
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `districts` (`id` integer, `name` varchar(255) not null, `regionId` integer, `createdAt` datetime not null default CURRENT_TIMESTAMP, `updatedAt` datetime not null default CURRENT_TIMESTAMP, foreign key(`regionId`) references `regions`(`id`), primary key (`id`))
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `communities` (`id` integer, `name` varchar(255) not null, `districtId` integer, `createdAt` datetime not null default CURRENT_TIMESTAMP, `updatedAt` datetime not null default CURRENT_TIMESTAMP, foreign key(`districtId`) references `districts`(`id`), primary key (`id`))
  ''',
  '''
  CREATE TABLE IF NOT EXISTS "groups" ( "id" integer, "name" varchar(255), "about" varchar(255), "createdAt" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP, "updatedAt" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP, "communityId" INTEGER not null, PRIMARY KEY("id"), foreign key(`communityId`) references `communities`(`id`) )
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `languages` ( `id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` VARCHAR(200) NOT NULL, `code` VARCHAR(50) NOT NULL, `createdAt` datetime not null default current_timestamp, `updatedAt` datetime not null default current_timestamp )
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `products` (`id` integer, `name` varchar(255) not null, `about` varchar(255), `createdAt` datetime not null default CURRENT_TIMESTAMP, `updatedAt` datetime not null default CURRENT_TIMESTAMP, primary key (`id`))
  ''',
  '''
  CREATE TABLE IF NOT EXISTS "suppliers" ( "id" integer, "firstName" varchar(255) NOT NULL, "lastName" varchar(255) NOT NULL, "about" varchar(255) NOT NULL, "gender" text CHECK(`gender` in ('female','male')), "phoneNumber" varchar(255) NOT NULL DEFAULT '------', "organizationId" integer, "communityId" integer NOT NULL, "membershipCode" varchar(255) NOT NULL, "productId" integer, "createdAt" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP, "updatedAt" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP, "age" INTEGER, "groupId" INTEGER, FOREIGN KEY("communityId") REFERENCES "communities"("id"), FOREIGN KEY("productId") REFERENCES "products"("id"), FOREIGN KEY("organizationId") REFERENCES "groups"("id"), PRIMARY KEY("id") )
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `transactions` (`id` integer, `date` datetime, `payment` text check (`payment` in ('unpaid', 'paid', 'partially paid')), `cost` float not null, `amountPaid` float not null default '0', `productId` integer not null, `supplierId` integer not null, `collectorId` integer not null, `currencyId` integer not null, `yield` float not null, `sacs` int not null, `status` text check (`status` in ('collected', 'shipped', 'delivered')) not null default 'collected', `createdAt` datetime not null default CURRENT_TIMESTAMP, `updatedAt` datetime not null default CURRENT_TIMESTAMP, foreign key(`productId`) references `products`(`id`), foreign key(`supplierId`) references `suppliers`(`id`), foreign key(`collectorId`) references `users`(`id`), foreign key(`currencyId`) references `currencies`(`id`), primary key (`id`))
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `transits` (`id` integer, `started` datetime not null, `journey` varchar(255), `ended` datetime, `transactionId` integer not null, `createdAt` datetime not null default CURRENT_TIMESTAMP, `updatedAt` datetime not null default CURRENT_TIMESTAMP, foreign key(`transactionId`) references `transactions`(`id`), primary key (`id`))
  ''',
  '''
  CREATE TABLE IF NOT EXISTS `users` (`id` integer, `firstName` varchar(255) not null, `lastName` varchar(255) not null, `otherNames` varchar(255), `email` varchar(255), `phone` varchar(255) not null, `password` varchar(255) not null, `countryId` integer not null, `roles` text check (`roles` in ('employee', 'admin', 'collector')), `status` text check (`status` in ('active', 'inactive', 'blocked', 'frozen')), `confirmed` text check (`confirmed` in ('true', 'false')) not null default 'false', `createdAt` datetime not null default CURRENT_TIMESTAMP, `updatedAt` datetime not null default CURRENT_TIMESTAMP, foreign key(`countryId`) references `countries`(`id`), primary key (`id`))
  '''
];
