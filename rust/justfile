# move bin.nix files under nix/
# to the correct place
# for the new package name $packageName
# (i.e. $packageName.nix)
# delete this after running it
setup packageName:
    mv nix/dev-shells/bin.nix "nix/dev-shells/{{ packageName }}.nix"
    mv nix/packages/bin.nix "nix/packages/{{ packageName }}.nix"
    rm Cargo.lock Cargo.toml
    # pass --vcs none to disable addition to .gitignore
    # (which would add the Cargo.lock to it)
    cargo init --vcs none --lib --edition 2021 --name "{{ packageName }}"
    # generate inital lockfile
    cargo build
    # make sure nix sees new *.nix files
    git add .

build:
    cargo build

build-release:
    cargo build --release

run:
    cargo run

run-release:
    cargo run --release

format:
    cargo fmt --check
    eclint -exclude "{Cargo.lock,flake.lock}"

format-fix:
    cargo fmt
    eclint -exclude "{Cargo.lock,flake.lock}" -fix

lint:
    cargo clippy

lint-fix:
    cargo clippy --fix

reuse:
    reuse lint
