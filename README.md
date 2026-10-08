# Iron Club — Gym Management System

A working Next.js App Router / React / TypeScript gym management project with a persistent SQLite database, responsive staff interface and printable payment receipts. It uses Vinext, a Next.js API-compatible Cloudflare runtime, Cloudflare D1 and Drizzle migrations. The UI is configured for Philippine pesos and Asia/Manila time.

Portfolio demonstration by RowLee Tanawan. The implementation uses Next.js-compatible App Router APIs with the Vinext runtime; deployment targets Cloudflare Workers. It is not a conventional standalone `next dev` deployment.

## Features

- Dashboard: current member access, daily attendance, monthly recorded payments, balances and upcoming classes.
- Members: create/edit contact information, search/filter, view full records, suspend/archive/reactivate, export CSV.
- Plans: create packages with calendar-day duration and price; enable/disable new assignments.
- Memberships: assign terms, renew from a chosen future date, prevent overlaps, preserve price and payment history.
- Attendance: searchable front desk, current-access checks, one visit per day, recent history and CSV export.
- Classes: schedule title/trainer/date/time/duration/capacity, book members, view rosters, remove future bookings, cancel/reopen classes.

## Technology

React, TypeScript, Next.js-compatible App Router, Vinext, Vite and responsive CSS. Cloudflare D1 SQLite and Drizzle migrations provide persistent data.

## Run locally

Node.js 22.13+ is required. Follow [installation, database initialization and walkthrough instructions](docs/SETUP.md), including the project-specific migration command. Dependencies and local database files are excluded from source control.

## Screenshots

Actual application screenshots are pending capture. No mockup is presented as a running application screenshot.

## Project layout

- `app/page.tsx`: application interface
- `app/globals.css`: responsive styling
- `app/api/`: server workflows, where applicable
- `db/` and `drizzle/`: schema and migrations, where applicable
- `docs/SETUP.md`: full setup, workflow rules and limitations

## Demo scope

Use fictional data for portfolio demonstrations. See [documented limitations](docs/SETUP.md) before deployment; authentication, payment integrations and operational safeguards vary by project and are not implied by the portfolio presentation.
