# New Mac Setup

Step-by-step, in order. Steps marked **(manual)** can't be scripted — Apple
account sign-in and 1Password unlock both need a human in the loop.

1. **(manual)** Sign into the Mac App Store (System Settings → Apple ID).
   The Brewfile installs `mas`-managed apps (Keynote, Magnet, Numbers,
   Xcode); skip this and that step just warns and moves on — see step 4.

2. Clone this repo over HTTPS (you have no SSH key registered yet):

   ```bash
   git clone https://github.com/jeanlucaslima/dotfiles.git
   cd dotfiles
   ```

3. Run the bootstrap script:

   ```bash
   ./bootstrap.sh
   ```

   It installs Homebrew, everything in `Brewfile` (CLI tools, casks, fonts,
   Mac App Store apps), Oh My Zsh, stows every dotfiles package into
   `$HOME`, and applies `macos-defaults.sh`.

4. If step 3 printed a `brew bundle` warning (usually the App Store apps
   from a skipped step 1), sign in now and re-run:

   ```bash
   brew bundle install --file=Brewfile
   ```

5. **(manual)** Open 1Password (installed in step 3), sign in, and enable
   Settings → Developer → "Use the SSH Agent". Confirm your ed25519 key is
   in the vault (or create one there) — this repo's `git` and `ssh`
   packages assume 1Password holds the private key, not a raw
   `ssh-keygen`'d file.

6. **(manual)** Save the key's public half to `~/.ssh/id_ed25519.pub`
   (copy the public key text from 1Password's key details into that file).
   It must match the fingerprint already in
   `git/.config/git/allowed_signers`, or local signature verification
   (`git log --show-signature`) won't recognize it.

7. **(manual)** Add that public key to GitHub as both key types:

   ```bash
   gh ssh-key add ~/.ssh/id_ed25519.pub --type authentication
   gh ssh-key add ~/.ssh/id_ed25519.pub --type signing
   ```

8. Verify commit signing works:

   ```bash
   git commit --allow-empty -m "test" && git log --show-signature -1
   ```

9. Restart your shell (or `source ~/.zshrc`) to pick up the prompt,
   aliases, and completions.

10. Ongoing maintenance: run `bruh` any time — it updates Homebrew, mas,
    mise, npm/bun/pnpm/yarn, rustup, pip, gem, etc. in one pass.
    `bruh --dry-run` previews, `bruh -h` lists steps.
