CREATE TABLE `checkins` (
	`id` text PRIMARY KEY NOT NULL,
	`member_id` text NOT NULL,
	`day` text NOT NULL,
	`checked_at` text NOT NULL,
	FOREIGN KEY (`member_id`) REFERENCES `members`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `member_day_uq` ON `checkins` (`member_id`,`day`);--> statement-breakpoint
CREATE TABLE `classes` (
	`id` text PRIMARY KEY NOT NULL,
	`title` text NOT NULL,
	`trainer` text NOT NULL,
	`starts_at` text NOT NULL,
	`duration` integer NOT NULL,
	`capacity` integer NOT NULL,
	`status` text DEFAULT 'Scheduled' NOT NULL
);
--> statement-breakpoint
CREATE TABLE `members` (
	`id` text PRIMARY KEY NOT NULL,
	`code` text NOT NULL,
	`name` text NOT NULL,
	`email` text NOT NULL,
	`phone` text NOT NULL,
	`status` text DEFAULT 'Active' NOT NULL,
	`joined_at` text NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `member_code_uq` ON `members` (`code`);--> statement-breakpoint
CREATE UNIQUE INDEX `member_email_uq` ON `members` (`email`);--> statement-breakpoint
CREATE TABLE `memberships` (
	`id` text PRIMARY KEY NOT NULL,
	`member_id` text NOT NULL,
	`plan_id` text NOT NULL,
	`start_date` text NOT NULL,
	`end_date` text NOT NULL,
	`amount_cents` integer NOT NULL,
	`paid_cents` integer DEFAULT 0 NOT NULL,
	`created_at` text NOT NULL,
	FOREIGN KEY (`member_id`) REFERENCES `members`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`plan_id`) REFERENCES `plans`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `membership_member_idx` ON `memberships` (`member_id`);--> statement-breakpoint
CREATE TABLE `payments` (
	`id` text PRIMARY KEY NOT NULL,
	`membership_id` text NOT NULL,
	`amount_cents` integer NOT NULL,
	`method` text NOT NULL,
	`reference` text NOT NULL,
	`created_at` text NOT NULL,
	FOREIGN KEY (`membership_id`) REFERENCES `memberships`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `payment_ref_uq` ON `payments` (`reference`);--> statement-breakpoint
CREATE TABLE `plans` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`days` integer NOT NULL,
	`price_cents` integer NOT NULL,
	`active` integer DEFAULT 1 NOT NULL
);
--> statement-breakpoint
CREATE TABLE `registrations` (
	`id` text PRIMARY KEY NOT NULL,
	`class_id` text NOT NULL,
	`member_id` text NOT NULL,
	`created_at` text NOT NULL,
	FOREIGN KEY (`class_id`) REFERENCES `classes`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`member_id`) REFERENCES `members`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `class_member_uq` ON `registrations` (`class_id`,`member_id`);