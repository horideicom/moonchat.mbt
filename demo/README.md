# MoonChat Demo (JS)

## Build

```bash
moon build --target js cmd/main
```

## Run locally

Serve the repo root and open the demo page:

```bash
python3 -m http.server --directory .
```

Then visit:

```
http://localhost:8000/demo/
```

If you build in debug mode (`moon build --target js -g cmd/main`), update the
script path in `demo/index.html` to `../target/js/debug/build/cmd/main/main.js`.
