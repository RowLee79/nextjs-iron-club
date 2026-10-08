# Iron Club — Gym Management System

A working Next.js App Router / React / TypeScript gym management project with a persistent SQLite database, responsive staff interface and printable payment receipts. It uses Vinext, a Next.js API-compatible Cloudflare runtime, Cloudflare D1 and Drizzle migrations. The UI is configured for Philippine pesos and Asia/Manila time.

## Features

- Dashboard: current member access, daily attendance, monthly recorded payments, balances and upcoming classes.
- Members: create/edit contact information, search/filter, view full records, suspend/archive/reactivate, export CSV.
- Plans: create packages with calendar-day duration and price; enable/disable new assignments.
- Memberships: assign terms, renew from a chosen future date, prevent overlaps, preserve price and payment history.
- Attendance: searchable front desk, current-access checks, one visit per day, recent history and CSV export.
- Classes: schedule title/trainer/date/time/duration/capacity, book members, view rosters, remove future bookings, cancel/reopen classes.
- Class booking checks: membership covers the session date, capacity, unique registration, and overlapping sessions.
- Payments: record partial or full manual payments, prevent overpayment, view/print receipts and export history.
- Reports: 7-day visit chart, plan distribution, current access and outstanding memberships.
- Sample data: 12 fictional members, 3 plans, payments, visits and 6 future classes.

## Requirements

Node.js 22.13+ and npm. Internet access is needed for installation. Windows, macOS or Linux with a current Node installation works. Use the included lockfile.

## Run locally

1. Extract this archive. Open a terminal in the `iron-club` folder containing package.json.
2. Install dependencies:

   `npm ci`

3. Build the application:

   `npm run build`

4. Create the local database schema (run once for each new local database):

   `npx wrangler d1 execute site-creator-d1 --local --config dist/server/wrangler.json --persist-to .wrangler/state --file drizzle/0000_wild_doomsday.sql`

5. Start:

   `npm start`

6. Open the localhost URL in the terminal, normally http://127.0.0.1:8787.
7. Click **Load sample gym** or start with **Add member** and create your own plans in Memberships.

For hot reload, use `npm run dev` after initial schema setup. The local D1 data is stored under `.wrangler/state` and excluded from version control. If your dev runtime uses a separate persistence location, initialize its DB with the included SQL using the same binding/config and persistence path as that server. The build/start workflow above has an explicit shared persistence path.

## Try the main workflows

- Members: open Alex Rivera, edit contact details and inspect the membership history.
- Attendance: check in a current member. A second check-in that day is rejected. An expired/suspended member is blocked.
- Memberships: assign a plan to a new member. Renewals must start after the last assigned term ends; overlapping terms are rejected.
- Payments: choose an outstanding membership, enter an already received payment, then view or print its receipt. Payment method labels do not integrate with GCash, banks or terminals.
- Classes: select Book member, choose a member with coverage on the class date, then inspect the roster. Remove a future booking to free capacity.
- Reports: inspect the visit chart and export outstanding terms.

## Validation commands

`npx tsc --noEmit`

`node tests/workflows.mjs`

`npm run build`

The API workflow test uses an isolated in-memory SQLite database and the actual route implementation. It covers sample data, member email uniqueness, access/term overlaps, payment balances, duplicate attendance, class capacity/conflicts, removal/cancellation, suspension and invalid input. It does not modify the running app's database. Browser interaction tests have not been included.

## Code map

- `app/page.tsx`: staff screens, dialogs, search/filter, charts, exports and receipts.
- `app/globals.css`: responsive desktop/mobile design and receipt print stylesheet.
- `app/api/gym/route.ts`: server validation and persistent operations.
- `db/schema.ts`: Drizzle schema for members, plans, memberships, payments, check-ins, classes and registrations.
- `drizzle/`: initial SQLite migration and migration metadata.
- `tests/workflows.mjs`: API business-rule checks with transactional SQLite adapter.
- `vite.config.ts`, `build/`, `scripts/`: Next.js-compatible Worker build/runtime.
- `.openai/hosting.json`: D1 binding configuration. The ZIP removes hosted Site identifiers.

## API summary

GET `/api/gym` returns the dashboard datasets.

GET `/api/gym?memberId=ID` returns a member profile, membership/payment history, visits and class bookings.

POST `/api/gym` receives JSON with an `action`:

- member: name, email, phone; optional id updates an existing member.
- memberStatus: id, status (Active, Suspended, Archived).
- plan: name, days, priceCents; planStatus: id, active (0 or 1).
- membership: memberId, planId, startDate (YYYY-MM-DD).
- payment: membershipId, amountCents, method.
- checkin: id (member ID).
- class: title, trainer, startsAt (ISO date with offset), duration, capacity.
- classStatus: id, status (Scheduled or Cancelled).
- register: classId, memberId; unregister: id (registration ID).
- seed: loads the sample workspace only when there are no members.

Money uses integer centavos. New membership start dates cannot be in the past. A 30-day plan includes the start date and ends 29 days later. Payments insert and update balances atomically. Attendance and registrations use database uniqueness constraints; capacity and overlap checks are enforced in the booking INSERT.

## Deployment

The private hosted version manages D1 and migrations automatically. For an independent Cloudflare deployment, create a D1 database, bind it as DB, configure the built Worker and static assets, apply migrations to the remote DB, and deploy. Do not point production at the local placeholder DB ID. Next.js App Router conventions are used, but this distribution's server binding is Cloudflare-specific; deploying with a plain `next start` requires replacing the D1 adapter and runtime build configuration.

## Scope and production requirements

This is a functional private staff demo, with no application-level staff login or role authorization. Keep it private. Before public/commercial use, add authenticated staff roles and API authorization, rate limiting, audit logs, privacy/retention policies, backup/recovery and deployment-specific security tests. Use fictional data for demos.

Manual payments are records of money already received; there is no payment gateway, automated billing, refunds, tax invoicing, payroll, biometric integration, access hardware, email/SMS delivery, member self-service or medical/fitness assessments. Receipts are not tax invoices. Trainer names are stored on sessions, not separate employee accounts. Cancelling a class retains its roster for history; removing future bookings is a separate action. Suspending a member immediately blocks new check-ins/registrations, while historical memberships/payments/bookings remain. Unpaid balances do not block valid membership access. Payment entries are immutable in the UI; reconciliation and refunds are outside this demo.

Loaded report limits: 1,000 members/memberships/payments, 500 recent check-ins, 300 classes. The attendance picker shows 12 search matches and recent attendance lists 50 records. Reports use the loaded datasets, not unlimited accounting totals.
