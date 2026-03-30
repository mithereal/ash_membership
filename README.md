# AshMembership

A runtime authorization engine for Ash that supports:

* Hot-reloadable rules
* ABAC-style evaluation
* ETS caching for performance
* Ash Policy integration (zero manual checks)
* Optional query pushdown

---

# ✨ Features

* **Runtime rules** — update permissions without recompiling
* **Hot reload** — changes propagate instantly across nodes
* **ETS caching** — ultra-fast authorization checks
* **Ash-native policies** — works seamlessly with Ash resources
* **Provider system** — plug in ABAC, hybrid, or custom logic
* **Query filtering** — push authorization into the database layer

---

# 🧠 Architecture Overview

```
                +----------------------+
                |      Database        |
                | (rules / tuples)     |
                +----------+-----------+
                           |
                           v
                +----------------------+
                |     Rule Loader      |
                | (DB → ETS cache)     |
                +----------+-----------+
                           |
                           v
                +----------------------+
                |     ETS Cache        |
                | (compiled rules)     |
                +----------+-----------+
                           |
                           v
                +----------------------+
                |   Runtime Engine     |
                | (fast evaluation)    |
                +----------+-----------+
                           |
                           v
                +----------------------+
                |   Ash Policies       |
                | (zero manual checks)  |
                +----------------------+
```

---

# 🚀 Installation

## 1. Add dependency

In your `mix.exs`:

```elixir
def deps do
  [
    {:ash_membership,">= 0.0.0"}
  ]
end
```

---

## 2. Run installer

```bash
mix ash_membership.install
```

---

## 3. Configure provider

```elixir
# config/config.exs

config :ash_membership,
  provider: AshMembership.Providers.Hybrid
```

---

## 4. Add Ash Policy

In any Ash resource:

```elixir
policies do
  policy always() do
    check AshMembership.Policy.Check
  end
end
```

---

## 5. Start required services

Add to your application:

```elixir
children = [
  {Phoenix.PubSub, name: :ash_membership_pubsub},
  AshMembership.Watcher
]
```

---

# 🧩 How It Works

## Rule Flow

```
Admin/API → Database → Rule Loader → ETS Cache → Engine → Ash Policy
```

---

## Hot Reload Flow

```
Rule updated
   ↓
Database write
   ↓
Cache cleared
   ↓
PubSub broadcast
   ↓
All nodes reload cache
   ↓
New rules active instantly
```

---

## Query Pushdown Flow

```
Ash query
   ↓
AshMembership.Query
   ↓
Compiled filter injected
   ↓
Database executes filtered query
```

---

# 🔐 Rule Model

Rules are stored in the database:

```elixir
%{
  resource: "MyApp.Account",
  action: "read",
  conditions: %{
    "role" => "admin"
  }
}
```

---

# ⚡ Runtime Evaluation

Rules are:

* loaded from DB
* cached in ETS
* compiled into anonymous functions
* executed per request

---

# 🧠 Providers

### ABAC

Attribute-based logic

### Hybrid

Combines ABAC + future providers

---

# 🧪 Example

```elixir
AshMembership.Checker.allowed?(actor, resource, :read)
```

---

# 🔥 Advanced Concepts

## Compiled Rule Engine

Rules are compiled into executable functions for performance.

## ETS Cache

Avoids repeated DB calls and compilation overhead.

## PubSub Invalidation

Ensures consistency across distributed nodes.

# 🧭 Summary

AshMembership turns authorization into a **runtime system** instead of a compile-time constraint.

You gain:

* flexibility
* scalability
* real-time updates
* deep Ash integration

---

# 📦 License

MIT
