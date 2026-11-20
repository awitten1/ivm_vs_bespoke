# ivm_vs_bespoke

Compare PostgreSQL incremental view maintenance (`pg_ivm`) with SynnoDB (BespokeOLAP).

## Postgres + pg_ivm

```bash
./start-postgres.sh
```

Connects at `postgres://postgres:postgres@localhost:5432/postgres`.

## SynnoDB

The project environment is a uv-managed `.venv` on Python 3.13. `uv sync` installs the `SynnoDB` checkout in editable mode, including the factory stack the TPC-H notebook imports.

```bash
uv sync
uv run python -c "import synnodb"
uv run jupyter lab SynnoDB/tutorials/gen_tpch_demo.ipynb
```

Copy `.env.example` to `.env` and set `OPENAI_API_KEY` before generating an engine. The factory's Landlock sandbox only runs on Linux.
