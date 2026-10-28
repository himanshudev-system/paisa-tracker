# PaisaTrack — Native Android Personal Finance & Expense Tracker

PaisaTrack is a fast, private, offline-first native Android expense and budget tracker built with Kotlin, Jetpack Compose, and Material 3. It empowers users to log daily income and expenses in Indian Rupees (`₹`), monitor overall and category-level monthly budgets, and visualize spending habits with zero cloud setup or account friction.

## User Review & Critical Decisions

> [!IMPORTANT]
> All core product preferences from our planning check-in have been locked into this blueprint. Review the architecture and visual direction below, then click **Proceed** to start building the complete native Android application.

- **Budgeting Structure (Confirmed)**: Supports both an **overall monthly spending budget** and **per-category monthly limits** (e.g., Food, Shopping, Bills), complete with real-time progress bars and warning thresholds when nearing or exceeding limits.
- **Reports & Visualizations (Confirmed)**: Features an interactive **Category Spending Donut Chart** alongside a **6-Month Income vs. Expense & Category Trend Bar Chart** drawn natively with Jetpack Compose Canvas.
- **Indian Rupee Formatting (Confirmed)**: Formats all monetary values using the **Indian numbering system** (`₹1,25,000` and `₹1,25,000.50`) with proper Lakh/Thousand comma grouping (`en-IN` locale conventions).
- **Settings & Data Utilities (Confirmed)**: Includes **System / Light / Dark** theme selection, **CSV Export** via Android's native system file saver/share sheet, an **optional realistic sample data loader** for instant exploration, and a **Clear All Data** action guarded by a confirmation dialog.
- **Privacy & Offline-First Guarantee**: No login walls, cloud sync, or external paid APIs—100% of transactions, budgets, and preferences stay locally on the device.

---

## 1. Overview & Core Concept

- **What It Does**: PaisaTrack gives users an immediate, accurate pulse on their personal finances. Every logged rupee updates live dashboard balances, monthly savings calculations, category budget meters, and multi-month analytical charts automatically.
- **Target Audience / Persona**: Everyday Android users, students, salaried professionals, and freelancers in India who want a trustworthy, clutter-free daily money manager that works instantaneously offline.
- **Key Value**: Combines effortless 3-second transaction entry with rich financial clarity—real-time net savings, proactive budget alerts, searchable history, and clean visual reports.

---

## 2. User Experience & Visual Design

### Key User Flows

1. **First Launch & Dashboard Overview (`Home`)**:
   - Opens to a rich Emerald hero card displaying **Total Balance**, flanked by **Monthly Income**, **Monthly Expenses**, and **Net Monthly Savings** (with savings rate percentage).
   - Displays a **Monthly Budget Pulse** summary bar for the active month and the **Recent Transactions** feed.
   - When empty on first launch, presents a welcoming empty-state card offering a one-tap **Add First Transaction** button or a quick link to load sample data.
   - A prominent Floating Action Button (`+`) is accessible to log a new Income or Expense from key screens.

2. **Add, Edit & Delete Transactions**:
   - Tapping `+` (or tapping any existing transaction card to edit) opens a streamlined Material 3 modal sheet / form screen:
     -Segmented toggle for **Expense** vs. **Income**.
     - Large `₹` amount input with live validation (rejects empty, zero, negative, or malformed numbers with clear inline helper messages).
     - Title input, interactive Category selector chips (10 distinct categories: *Food, Transport, Shopping, Bills, Health, Education, Entertainment, Salary, Freelance, Other*), Material 3 Date Picker, and optional Note field.
   - Deleting a transaction from the edit sheet or swipe/delete action always triggers an explicit **Confirmation Dialog** before removal.

3. **Searchable & Filterable History (`Transactions`)**:
   - Instant search bar matching transaction titles, notes, or category names.
   - Filter bar with **Type chips** (*All, Expense, Income*), **Category selector**, and **Month switcher** so users can drill down into exact periods.
   - Grouped chronologically by date headers with daily net subtotals.

4. **Monthly Budget Management (`Budgets`)**:
   - Month switcher at the top (defaults to current month, allows planning or reviewing any month).
   - **Overall Monthly Budget Card**: Set or edit the master monthly spending cap; shows spent amount, remaining allowance (or overspent amount), and color-coded progress bar (Emerald `<75%`, Amber `75–99%`, Coral Red `100%+`).
   - **Category Budgets List**: Set individual monthly caps for spending categories (*Food, Transport, Shopping, Bills, Health, Education, Entertainment, Other*) and see exact progress per category.

5. **Visual Analytics (`Reports`)**:
   - **Category Breakdown Donut Chart**: Interactive multi-segment ring chart showing each expense category's share (`%` and `₹` total) for the selected month. Tapping a segment or legend row highlights that category's exact spend and transaction count.
   - **Monthly Trend Bars**: Comparative vertical bar chart across recent months showing Income vs. Expenses and net savings trajectory.

6. **Preferences & Data Management (`Settings`)**:
   - **Theme Mode**: Choose *System Default*, *Light*, or *Dark* with instant reactive switching.
   - **Export to CSV**: Generates a clean, spreadsheet-ready CSV of all saved transactions using Android's native document picker (zero storage permissions required).
   - **Load Sample Data**: Optional one-tap utility to populate realistic Indian Rupee income, expenses, and monthly budgets for testing charts and filters.
   - **Clear All Data**: Protected by a destructive-action **Confirmation Dialog** that wipes transactions and budgets cleanly when confirmed.

### Visual Identity & Theme

- **Aesthetic Direction**: *Modern Emerald Fintech* — crisp, calm, high-trust financial clarity inspired by modern wealth apps, pairing deep forest-emerald hero surfaces with airy, tactile Material 3 cards.
- **Color Palette & Mood**:
  - **Light Mode**: Warm Alabaster background (`#F6F9F7`), pure crisp card surfaces (`#FFFFFF`), Deep Forest Emerald primary (`#067647`), Mint-Sage secondary containers (`#DCFCE7`), Slate Ink text (`#0F172A`).
  - **Dark Mode**: Deep Obsidian-Pine background (`#0A110E`), elevated Charcoal-Moss cards (`#131E19`), Luminous Emerald primary (`#34D399`), muted Jade containers (`#064E3B`), Crisp Off-White text (`#F1F5F9`).
  - **Semantic Financial Accents**: Income Emerald (`#10B981`), Expense Coral (`#EF4444`), Budget Caution Amber (`#F59E0B`), plus distinct harmonious category badge tints.
- **Typography & Hierarchy**:
  - **Display & Numerals**: *Plus Jakarta Sans* (bundled locally) for bold rupee balances, section headers, and crisp tabular-feeling numbers.
  - **Body & Labels**: *Inter* (bundled locally) for high-legibility transaction titles, notes, chips, and dates, scaled in `sp` for full accessibility support.
- **Component Styling & Layout**:
  - Edge-to-edge layout respecting status bar and gesture navigation insets.
  - Asymmetric hero balance card with subtle radial gradient depth (`drawBehind`), paired with clean rounded (`20dp`) Material 3 surface cards.
  - Adaptive layout support: standard 5-tab `NavigationBar` on phones (`Home`, `Transactions`, `Budgets`, `Reports`, `Settings`) with fluid width constraints so cards remain balanced across screen sizes and orientations.
- **Interactive Feedback & Motion**:
  - Smooth animated progress bars and chart sweeps (`animateFloatAsState` with spring physics).
  - Material ripple feedback on all interactive cards and minimum `48dp` touch targets.
  - Snackbar confirmations on transaction save, CSV export completion, sample data load, and confirmed deletions.

---

## 3. Key Product Decisions & Trade-Offs

- **Decision 1: Single Unified Budget Table Keyed by Month & Optional Category**
  - *Chosen Approach*: Store monthly budgets keyed by `yearMonth` (e.g., `2026-10`) and `category` (`OVERALL` for the master monthly budget, or a specific category identifier for category limits), enforced by a unique composite index.
  - *Why*: Eliminates data duplication, makes upserting a budget effortless, and lets users carry forward or customize budgets per month while calculating live progress directly against that month's Room transaction stream.
  - *Alternatives Considered*: Global static budgets that ignore months (rejected because real income and spending vary month to month).

- **Decision 2: Native Jetpack Compose Canvas Charts Over Heavy External Chart Libraries**
  - *Chosen Approach*: Build bespoke, theme-aware Donut and Monthly Trend Bar charts directly with Jetpack Compose `Canvas`, touch hit-testing, and spring animations.
  - *Why*: Guarantees zero dependency bloat, seamless Light/Dark Material 3 color integration, crisp `₹` Indian formatting on labels, and interactive segment selection without third-party rendering quirks.
  - *Alternatives Considered*: Third-party chart wrappers (often lag behind Material 3 theming or add unnecessary APK weight).

- **Decision 3: Zero-Permission CSV Export via Storage Access Framework**
  - *Chosen Approach*: Use Android's `CreateDocument("text/csv")` contract to let the user save their CSV anywhere (Downloads, Drive, local folders) without requesting any storage permissions.
  - *Why*: Complies strictly with modern Android privacy standards and Google Play policies while working reliably across all Android versions.

---

## 4. Technical Architecture & Data Strategy *(Technical Reference)*

### Architecture & Component Diagram

```text
┌───────────────────────────────────────────────────────────────────────────┐
│                        UI LAYER (Jetpack Compose + M3)                    │
│                                                                           │
│  ┌────────────────────── App Shell & Navigation ───────────────────────┐  │
│  │  Bottom NavigationBar: Home │ Transactions │ Budgets │ Reports │ ⚙  │  │
│  └──────┬───────────────┬──────────────┬──────────────┬───────────┬────┘  │
│         ▼               ▼              ▼              ▼           ▼       │
│  ┌────────────┐ ┌──────────────┐ ┌───────────┐ ┌───────────┐ ┌──────────┐ │
│  │ HomeScreen │ │ Transactions │ │  Budgets  │ │  Reports  │ │ Settings │ │
│  │ • Balance  │ │    Screen    │ │  Screen   │ │  Screen   │ │  Screen  │ │
│  │ • Savings  │ │ • Search Bar │ │ • Overall │ │ • Donut   │ │ • Theme  │ │
│  │ • Budget   │ │ • Type/Cat/  │ │   Cap     │ │   Chart   │ │ • Export │ │
│  │   Pulse    │ │   Month Chip │ │ • Per-Cat │ │ • Monthly │ │ • Sample │ │
│  │ • Recent   │ │ • Date Group │ │   Meters  │ │   Trends  │ │ • Clear  │ │
│  └──────┬─────┘ └──────┬───────┘ └─────┬─────┘ └─────┬─────┘ └────┬─────┘ │
│         └──────────────┴───────┬───────┴─────────────┴────────────┘       │
│                                ▼                                          │
│              ┌───────────────────────────────────┐                        │
│              │  Transaction Editor Modal &       │                        │
│              │  Destructive Confirmation Dialogs │                        │
│              └─────────────────┬─────────────────┘                        │
└────────────────────────────────┼──────────────────────────────────────────┘
                                 │ StateFlow<UiState> & User Intents
                                 ▼
┌───────────────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER (MVVM)                         │
│                                                                           │
│  ┌─────────────────────────────────────────────────────────────────────┐  │
│  │                         PaisaTrackViewModel                         │  │
│  │  • Combines reactive Room Flows + Filter/Month/Search StateFlows    │  │
│  │  • Computes real Balance, Monthly Income, Expenses & Net Savings    │  │
│  │  • Validates form inputs (amount > 0, non-blank title, valid date)  │  │
│  │  • Formats CSV payload & coordinates confirmation dialog states     │  │
│  └──────────────────────┬───────────────────────────┬──────────────────┘  │
└─────────────────────────┼───────────────────────────┼─────────────────────┘
                          │                           │
                          ▼                           ▼
┌──────────────────────────────────────┐ ┌──────────────────────────────────┐
│      DATA LAYER (Room + SQLite)      │ │   PREFERENCES LAYER (DataStore)  │
│                                      │ │                                  │
│  ┌────────────────────────────────┐  │ │  ┌────────────────────────────┐  │
│  │     FinanceRepository          │  │ │  │   ThemePreferencesStore    │  │
│  └──────────────┬─────────────────┘  │ │  │ • ThemeMode (SYSTEM /      │  │
│                 ▼                    │ │  │   LIGHT / DARK)            │  │
│  ┌────────────────────────────────┐  │ │  └────────────────────────────┘  │
│  │     PaisaTrackDatabase         │  │ └──────────────────────────────────┘
│  │  • TransactionDao (Flow + CRUD)│  │
│  │  • BudgetDao (Flow + Upsert)   │  │
│  │  • Versioned Schema Migrations │  │
│  └────────────────────────────────┘  │
└──────────────────────────────────────┘
```

### Data Model & State

- **`TransactionEntity` (Room Table `transactions`)**:
  - `id` (Auto-generated Primary Key `Long`)
  - `title` (`String`, indexed for fast search)
  - `amount` (`Double`, strictly positive rupee value)
  - `type` (`TransactionType`: `INCOME` or `EXPENSE`)
  - `category` (`TransactionCategory`: `FOOD`, `TRANSPORT`, `SHOPPING`, `BILLS`, `HEALTH`, `EDUCATION`, `ENTERTAINMENT`, `SALARY`, `FREELANCE`, `OTHER`)
  - `dateMillis` (`Long`, epoch timestamp indexed for fast chronological sorting and monthly range queries)
  - `note` (`String`, optional user memo)
- **`BudgetEntity` (Room Table `budgets`)**:
  - `id` (Auto-generated Primary Key `Long`)
  - `yearMonth` (`String` formatted as `YYYY-MM`, e.g., `2026-10`)
  - `categoryKey` (`String`: `"OVERALL"` for the master monthly budget, or the `TransactionCategory` name for category-specific budgets; unique composite index on `(yearMonth, categoryKey)`)
  - `limitAmount` (`Double`, strictly positive monthly cap in `₹`)
- **Database Versioning & Migrations**:
  - Configured with explicit Room schema versioning and a structured `Migration(1, 2)` pathway ready for safe future schema evolution without destructive data loss.

### Interactive Component & State Mapping

- **Dashboard Calculations (`Home`)**:
  - `Total Balance` = Sum of all `INCOME` transactions minus sum of all `EXPENSE` transactions across all time.
  - `Monthly Income` & `Monthly Expenses` = Filtered dynamically to the selected `yearMonth`.
  - `Monthly Savings` = `Monthly Income - Monthly Expenses` (displayed with positive green or deficit red indicator).
- **Transaction Editor & Validation**:
  - Validates amount text in real time: strips commas/currency symbols, parses numeric value, blocks `NaN`, `<= 0`, or excessively large overflow values, and highlights invalid fields inline before enabling save.
  - Switching between `EXPENSE` and `INCOME` smartly defaults or prioritizes relevant categories (e.g., *Salary* and *Freelance* highlighted for Income; *Food*, *Transport*, *Shopping*, *Bills*, etc. for Expense, while keeping all 10 categories available).
- **Search & Multi-Filter Pipeline (`Transactions`)**:
  - Reactive `combine` stream merges the Room transactions `Flow` with `searchQuery`, `selectedType`, `selectedCategory`, and `selectedYearMonth` to update the list and filtered summary totals instantaneously without blocking the main thread.
- **Budget Progress & Alerts (`Budgets`)**:
  - Joins active month `EXPENSE` totals (overall and per-category) with `BudgetEntity` records to compute `spent`, `limit`, `remaining`, and `progressRatio`, allowing inline creation, editing, or removal of any budget cap.
- **Confirmation Safety Rails**:
  - Deleting any transaction or invoking **Clear All Data** sets a pending confirmation state that opens an accessible Material 3 `AlertDialog` detailing the exact impact before executing the suspend DAO deletion.
