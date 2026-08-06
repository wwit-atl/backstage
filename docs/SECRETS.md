# Deploy secrets

Backstage's deploy secrets live in a single **age-encrypted JSON file on the deploy
host**, outside this repository:

```
~/.local/share/secrets/backstage.secrets.json.age
```

`.kamal/secrets` decrypts it once per deploy and pulls individual values out with
`kamal secrets extract`. Nothing secret is ever committed.

**Why `~/.local/share/secrets/` and not `~/.config/`.** yadm's worktree is `$HOME`.
In `$HOME/.gitignore`, `.local/` is an unconditional ignore, while `.config/*` is
an allowlist maintained by hand (`!.config/bash/`, `!.config/nvim/`, …) that grows
every time a new config is tracked. Both are ignored today; only one cannot be
un-ignored by a future edit made for an unrelated reason. Do not relocate this
file into `~/.config/`.

> **History note.** The production `SECRET_KEY_BASE` was committed to
> `config/deploy.yml` in `bb78157` (2024-11-21) and was public until 2026-08-06.
> That value is permanently burned — it remains in the git history of a public
> repository. It has been rotated. Do not reuse it.

## One-time setup

```bash
sudo apt install age

mkdir -p ~/.local/share/secrets
chmod 700 ~/.local/share/secrets
```

Write the plaintext JSON. Every key referenced in `.kamal/secrets` must be present:

```bash
cat > ~/.local/share/secrets/backstage.secrets.json <<'EOF'
{
  "SECRET_KEY_BASE": "",
  "KAMAL_REGISTRY_PASSWORD": "",
  "DB_PASSWORD": "",
  "POSTGRES_PASSWORD": "",
  "RDS_PASSWORD": "",
  "AWS_ACCESS_KEY_ID": "",
  "AWS_SECRET_ACCESS_KEY": "",
  "MANDRILL_APIKEY": "",
  "MANDRILL_TEST_APIKEY": "",
  "MANDRILL_WEBHOOK_KEY": ""
}
EOF

chmod 600 ~/.local/share/secrets/backstage.secrets.json
$EDITOR ~/.local/share/secrets/backstage.secrets.json   # fill in the values
```

Generate a fresh `SECRET_KEY_BASE` with:

```bash
ruby -rsecurerandom -e 'puts SecureRandom.hex(64)'
```

Encrypt, then destroy the plaintext:

```bash
age --passphrase --output ~/.local/share/secrets/backstage.secrets.json.age \
                          ~/.local/share/secrets/backstage.secrets.json
shred -u ~/.local/share/secrets/backstage.secrets.json
chmod 600 ~/.local/share/secrets/backstage.secrets.json.age
```

Store the passphrase somewhere you will still have it after a disk failure. If it
is lost, every secret must be regenerated from its upstream provider.

Verify before deploying:

```bash
bin/verify-secrets
```

Prints key names, lengths, a status flag, and the `SECRET_KEY_BASE` fingerprint —
never the values themselves.

> **Do not use `kamal secrets print` for this.** It writes every secret in
> plaintext to stdout. Piping it into something that masks the output is not a
> control: a broken pipe, a partially pasted one-liner, or a command recalled
> from shell history all expose the lot, and terminal scrollback keeps it. Any
> check that needs the values must consume them in a script, never on a terminal.

## Rotating a secret

Decrypt inside the `700` directory rather than `/tmp` — a redirect into `/tmp`
creates the file at the default umask and leaves it readable for the moment before
`chmod` lands.

```bash
cd ~/.local/share/secrets
age --decrypt backstage.secrets.json.age > backstage.secrets.json
$EDITOR backstage.secrets.json
age --passphrase --output backstage.secrets.json.age backstage.secrets.json
shred -u backstage.secrets.json

bin/kamal deploy
```

Rotating `SECRET_KEY_BASE` invalidates every active session — all members are
signed out once. That is expected.

## Adding a new secret

1. Add the key to the JSON (rotation procedure above).
2. Add a `NAME=$(kamal secrets extract NAME $SECRETS)` line to `.kamal/secrets`.
3. Add `NAME` to `env.secret` in `config/deploy.yml` — **never** `env.clear`.

## Constraint: no single quotes in secret values

`.kamal/secrets` passes the decrypted JSON to `kamal secrets extract` as a
single-quoted shell argument. JSON escapes `"` and `\` but leaves `'` untouched,
so a secret value containing a literal single quote will break the deploy.

Spaces are fine. Apostrophes are not. If a provider hands you one, regenerate the
credential rather than trying to escape it.

## Notes

- `env.clear` in `config/deploy.yml` is committed and world-readable. Only
  non-sensitive configuration belongs there.
- age prompts on `/dev/tty`, so deploys must be run from an interactive shell. If
  a non-interactive deploy is ever needed, switch to an age identity file
  (`age-keygen -o ~/.local/share/secrets/backstage.identity.age`, then
  `age --decrypt --identity ...`) and protect that file at mode 600 instead.
- Encryption at rest protects against disk images, snapshots, stray backups, and
  other accounts on the host. It does not protect against compromise of the
  `dyoung` account while the passphrase is cached or being entered.
