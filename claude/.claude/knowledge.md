# Knowledge Base

<!-- Organized by category. Each entry should be a concise, actionable learning. -->

## ActiveRecord

- For scopes that filter by a polymorphic `has_many ... as:` association, prefer `joins(:assoc).where(assoc: {...}).select(:id)` over `Target.where(poly_type_col: name, ...).select(:poly_fk_col)`. The association reflection encodes the polymorphic type column, type value, and foreign key — so `joins` stays correct through column renames. Direct subqueries hardcode all three and must be rewritten when the polymorphic columns change.
- `.order` chains; it does not override. If the relation already has an order (PaperTrail's `versions` association ships with `ORDER BY created_at ASC, id ASC`), then `.order(created_at: :desc).first` produces `ORDER BY created_at ASC, id ASC, created_at DESC` and returns the OLDEST row. Use `.reorder(...)` to override, or rely on `.last` (which inverts the whole order clause).

## Rails Migrations

- Never combine `add_column` with `disable_ddl_transaction!` — split column additions and concurrent indexes into separate migrations
- Never use `add_reference_concurrently` — fails on busy DBs due to lock timeouts. Manually add columns + index with lock retrier helpers instead
- Use `with_index_lock_retrier_config` block when adding concurrent indexes, `with_foreign_key_lock_retrier_config` for FKs — NOT for plain `add_column` on busy tables (online_migrations handles retries automatically for those)
- Never use `change_column_null :table, :col, false` — it scans the entire table while holding a lock. Use `add_not_null_constraint(validate: false)` then `validate_not_null_constraint` in a separate migration
- `change_column_null :table, :col, true` (making nullable) is fine — just drops the constraint
- When tables are new and only on an unmerged branch, modify the existing create migration directly instead of generating additional migrations
- Check `online_migrations` gem helpers in `config/initializers/online_migrations.rb` and `config/initializers/02_configuration/migration_actions.rb` when writing migrations
- Don't run migrations — user handles that step themselves
- Rollback script: `~/.local/bin/rollback-migrations <version1> <version2> ...` (list each version as separate arg, newest first — does NOT roll back "everything after" a single version)

## Sorbet

- Prefer `is_a?` checks over `T.cast` — `T.cast` bypasses runtime safety and is a last resort. Use `return unless x.is_a?(ExpectedType)` or `if x.is_a?` branches for type narrowing

## Testing

- Group concern tests under context blocks by type (scopes, callbacks, instance methods, etc.) — mirror how the concern is organized
- Don't test simple validations (`validates :name, presence: true`) or basic ActiveRecord behavior — only test real business logic, custom methods, conditional logic, callbacks with side effects, and status transitions

## Development Environment

- Docker containers run on a remote host accessed via `bin/dev` — don't try localhost or docker compose directly
- Run tests and Sorbet with `bundle exec` (e.g. `bundle exec rails test ...`, `bundle exec srb tc ...`), not `bin/rails` or `bin/dev`

## DataStream Syncing

- `DataStreamSyncer::Base#with_retries_and_attempt_caching` is NOT just a retry wrapper. After `MAX_ATTEMPTS` (3) failures it: (1) swallows the exception and returns `[]` so the error never reaches `ExceptionNotifier`/Sentry, (2) writes a `DataStreamSyncer.<id>.daily-failed-attempt.<date>` key to `Rails.cache` (8-day TTL), (3) calls `update_smart_disable_connection` which, if all 7 most recent days are marked failed AND the stream is `enabled? && automatic?`, calls `@data_stream.disable`, may call `Setting#disconnect_from_system` (if no other streams of that source remain active), and sends `DataStreamMailer.send_disconnection_notice` to the customer.
- Implication when refactoring a bespoke syncer through the generic `Base#hashed_data` (e.g. the SwiftPOS → `Pos::Client` refactor on `refactor/swiftpos-pos-integration-into-generic-interface`): any POS routed through `Base` is opted into smart-disable + error swallowing. SwiftPOS already had this on master via `get_location_transactions`. Syncers that didn't (e.g. Kounta, plain Doshii flows) would get new customer-visible behavior — verify before pointing them at `Base` in the `subclasses` hash.
- Note that `@data_stream.synced_at` is bumped in `sync!` even when `hashed_data` returned `[]` due to all retries failing — so `synced_at` is not a reliable "last successful sync" signal for syncers that go through this wrapper.
