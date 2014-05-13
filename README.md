# Formail

It takes form posts and turns them into emails.

    curl -X POST --data "from=yourmother@example.com&to=foo@example.com&subject=cats&text=ohai" http://localhost:3000/

The / endpoint compares the "to" field to a whitelist (found in conf/conf.js)

The /authed endpoint does not compare the "to" address to this whitelist, however you must also pass a "auth" parameter in order for your request to be accepted.

There is an optional "prepend" parameter on all requests. Any text in this field will be prepended to the subject line.
