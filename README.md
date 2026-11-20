# ivm_vs_bespoke

Compare PostgreSQL incremental view maintenance (`pg_ivm`) with SynnoDB (BespokeOLAP).

## Postgres + pg_ivm

```bash
./start-postgres.sh
```

Connects at `postgres://postgres:postgres@localhost:5432/postgres`.

## SynnoDB

The project environment is a uv-managed `.venv` on Python 3.13. `uv sync` installs the `SynnoDB` checkout in editable mode.

```bash
uv sync
uv run python -c "import synnodb"
uv run jupyter lab SynnoDB/tutorials/gen_tpch_demo.ipynb
```

Generating engines needs the factory extra and a key in `.env` (copy `.env.example`). That extra depends on Linux for its sandbox:

```bash
cp .env.example .env
uv sync --extra factory
```
