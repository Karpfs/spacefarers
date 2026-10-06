# Galactic Spacefarer Adventure

An SAP CAP (Node.js) application with a Fiori Elements List Report and Object Page
for managing galactic spacefarers.

## Features

- **Data model**: spacefarers with stardust collection, wormhole navigation skill,
  origin planet and spacesuit color, related to departments and positions
- **Secured OData V4 service**: full CRUD with draft support, available to
  authenticated users only
- **Planet-based data isolation**: users only see and edit spacefarers from their
  own planet
- **Event handlers**: validation and enhancement before creation, welcome email
  after creation
- **Fiori Elements UI**: list report with sorting, filtering and paging, object page
  with editing

## Getting started

Prerequisites: Node.js 20 or later.

```
npm install
npx cds watch
```

Open http://localhost:4004 and choose the application under *Web Applications*
(`index.html` for the standalone app, `test/flp.html#app-preview` for the launchpad
preview).

### Test users

| User  | Password | Planet |
|-------|----------|--------|
| alice | alice    | Earth  |
| bob   | bob      | Mars   |

Log in with both users (for example in separate private windows) to see the data
isolation: each user only sees spacefarers from their own planet.

## Project structure

| Path              | Content                                      |
|-------------------|----------------------------------------------|
| `db/`             | Data model and sample data (CSV)             |
| `srv/`            | Service definition and event handlers        |
| `app/spacefarers` | Fiori Elements application and UI annotations |
| `test/`           | Automated tests and sample HTTP requests     |

## Design decisions

### Authorization

The service requires an authenticated user. Access to spacefarers is restricted
with an instance-based condition that compares the spacefarer's origin planet with
the `planet` attribute of the user. When a spacefarer is created, the origin planet
is always set from the creating user's planet, so users cannot create spacefarers
for another planet.

For local development, mocked users are configured in `package.json`.

### Creating a spacefarer

Before a spacefarer is created:

- the stardust collection must not be negative,
- the wormhole navigation skill must be between 1 and 10,
- a welcome bonus of 10 is added to the stardust collection.

After a spacefarer is created, a welcome email is sent to their email address.
A failed email does not fail the creation.

### Email configuration

Without configuration, emails are only written to the log. To send real emails, set
these environment variables:

| Variable    | Description                 |
|-------------|-----------------------------|
| `SMTP_HOST` | SMTP server host            |
| `SMTP_PORT` | SMTP server port (default 587) |
| `SMTP_USER` | SMTP user                   |
| `SMTP_PASS` | SMTP password               |

### Stardust collection status

The list report shows each spacefarer's stardust collection status. The status is
derived from the stardust collection value and displayed with a semantic color:

| Stardust collection | Status | Color  |
|---------------------|--------|--------|
| 100 or more         | High   | Green  |
| 50 to 99            | Medium | Orange |
| below 50            | Low    | Red    |

The status is not stored in the database. It is a virtual field
(`stardustCriticality`) calculated in an `after READ` handler in
`srv/spacefarer-service.js`, so it always reflects the current value. The thresholds
are defined there and can be adjusted in one place.

## Testing

```
npm test
```

The tests cover authentication, planet-based data isolation, validation and
enhancement. For manual testing, `test/spacefarers.http` contains sample requests
for the VS Code REST Client extension.

## Production considerations

This project is set up for local development with SQLite and mocked authentication.
For a productive deployment the following would be needed:

- SAP HANA Cloud as the database
- XSUAA or IAS for authentication, with the `planet` attribute mapped to users
- An SMTP server or mail service configured through the environment variables above
