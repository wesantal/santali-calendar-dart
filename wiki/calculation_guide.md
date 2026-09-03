# Calculation Guide

The astronomical logic behind the Santali lunisolar calendar — how leap years are calculated and why the 19-year Metonic cycle was chosen.

**Original Guide:** [https://calendar.wesantal.org/docs/calculation-guide](https://calendar.wesantal.org/docs/calculation-guide)

---

## Table of Contents

1. [Solar vs. Lunar Years](#1-solar-vs-lunar-years)
2. [The 3-Year Rule (And Why It Fails)](#2-the-3-year-rule-and-why-it-fails)
3. [The Metonic Cycle Solution](#3-the-metonic-cycle-solution)
4. [Spacing the 7 Leap Years](#4-spacing-the-7-leap-years)
5. [The Bank Account Analogy](#5-the-bank-account-analogy)
6. [Dart Implementation](#6-dart-implementation)
7. [Why Sarcha After Pus Bonga](#7-why-sarcha-after-pus-bonga)
8. [Continuous Metonic Chain](#8-continuous-metonic-chain)
9. [Base Year & Chandradarshan](#9-base-year--chandradarshan)

---

## 1. Solar vs. Lunar Years

The Santali calendar is a **lunisolar** calendar — it tracks both moon phases (for months) and the solar year (for seasons).

| Unit                     | Duration                     |
| ------------------------ | ---------------------------- |
| 1 Solar Year (Tropical)  | 365.24219 days               |
| 1 Lunar Month (Synodic)  | 29.53059 days                |
| 1 Lunar Year (12 months) | 354.36708 days               |
| **Annual Deficit**       | **10.87511 days (~11 days)** |

Every year the lunar calendar falls behind the solar calendar by approximately **11 days**. If left uncorrected, the calendar would drift completely out of sync with the seasons — Magh would eventually fall in summer.

## 2. The 3-Year Rule (And Why It Fails)

To fix the 11-day deficit, most traditional rules add an extra month every 3 years. The math for 3 years:

- Accumulated drift in 3 years: `10.87511 × 3 = 32.62533 days`
- Length of 1 leap month: `29.53059 days`
- Remaining unadjusted drift: `3.09474 days`

**The 3-Day Problem:** Even after adding a leap month, there is a residual drift of ~3.1 days every 3 years. In 18 years = ~18 days of error. In 114 years = ~117 days of error.

## 3. The Metonic Cycle Solution

In 432 BCE, the Greek astronomer Meton discovered a near-perfect mathematical alignment:

```
19 Solar Years ≈ 235 Lunar Months
```

- 19 Solar Years = `19 × 365.24219 = 6939.6016 days`
- 235 Lunar Months = `235 × 29.53059 = 6939.6886 days`
- Difference = 0.087 days (only ~2.1 hours of drift per 19 years!)

Instead of adding exactly 6 leap months in 18 years, we must add **7 leap months in 19 years**. The accumulated 3-day residuals from each cycle add up to form this 7th leap month, completely wiping out the drift.

## 4. Spacing the 7 Leap Years

If we have to place 7 leap years within a 19-year window, the 19 years must be divided into a combination of **3-year and 2-year gaps**:

```
3 + 3 + 2 + 3 + 3 + 3 + 2 = 19 years
```

This creates the specific leap positions within the 19-year cycle:

| Position | Gap from Previous | Leap Year? |
| -------- | ----------------- | ---------- |
| 1        | —                 | Yes        |
| 2        | 1 year            | No         |
| 3        | 1 year            | No         |
| 4        | 3 years           | Yes        |
| 5        | 1 year            | No         |
| 6        | 1 year            | No         |
| 7        | 3 years           | Yes        |
| 8        | 1 year            | No         |
| 9        | 2 years           | Yes        |
| 10       | 1 year            | No         |
| 11       | 1 year            | No         |
| 12       | 3 years           | Yes        |
| 13       | 1 year            | No         |
| 14       | 1 year            | No         |
| 15       | 3 years           | Yes        |
| 16       | 1 year            | No         |
| 17       | 1 year            | No         |
| 18       | 3 years           | Yes        |
| 19       | 1 year            | No         |

You cannot have a leap year just 1 year after the previous leap year. A single year only generates 11 days of drift, which is not enough to form a 30-day month. The 2-year gap at position 9 prevents this.

## 5. The Bank Account Analogy

Think of the calendar as a bank account:

- **Earning:** Every solar year, ~11 extra days are deposited
- **Spending:** When the balance exceeds 30 days, withdraw 30 days for a leap month

| Year | Running Balance | Leap Month?     | After Withdrawal |
| ---- | --------------- | --------------- | ---------------- |
| 2024 | 11              | No              | 11               |
| 2025 | 22              | No              | 22               |
| 2026 | 33              | Yes             | 3                |
| 2027 | 14              | No              | 14               |
| 2028 | 25              | No              | 25               |
| 2029 | 36              | Yes             | 6                |
| 2030 | 17              | No              | 17               |
| 2031 | 28              | No              | 28               |
| 2032 | 39              | Yes             | 9                |
| 2033 | 20              | No              | 20               |
| 2034 | 31              | Yes (2-yr gap)  | 1                |
| 2035 | 12              | No              | 12               |
| 2036 | 23              | No              | 23               |
| 2037 | 34              | Yes             | 4                |
| 2038 | 15              | No              | 15               |
| 2039 | 26              | No              | 26               |
| 2040 | 37              | Yes             | 7                |
| 2041 | 18              | No              | 18               |
| 2042 | 29              | No              | 29               |
| 2043 | 40              | Yes             | 10               |
| 2044 | 21              | No              | 21               |
| 2045 | 32              | Yes — new cycle | ~0               |

By the end of exactly 19 years, the fractional math perfectly balances out and the bank balance hits approximately 0, completely resetting the cycle.

## 6. Dart Implementation

The `santali_calendar` package implements this logic with the cycle anchored to **2026** (a known leap year).

### Constants

```dart
const int metonicCycleStart = 2026;

const Set<int> metonicLeapPositions = {1, 4, 7, 9, 12, 15, 18};
```

### Leap Year Check

```dart
bool isLeapYear(int year) {
  final position = (((year - metonicCycleStart) % 19) + 19) % 19 + 1;
  return metonicLeapPositions.contains(position);
}
```

The double-modulo `((x % 19) + 19) % 19` handles negative years correctly, ensuring the formula works for any year.

### Using with SantaliCalendar

```dart
import 'package:santali_calendar/santali_calendar.dart';

final calendar = SantaliCalendar();

// Check leap years
isLeapYear(2026);  // true  (position 1)
isLeapYear(2027);  // false (position 2)
isLeapYear(2029);  // true  (position 4)
isLeapYear(2034);  // true  (position 9, 2-year gap)

// Year length depends on leap status
calendar.yearLength(2026);  // 384 (leap year: 354 + 30)
calendar.yearLength(2027);  // 354 (normal year)

// Get all months (13 in leap years, 12 otherwise)
final months = calendar.buildMonths(2026);  // 13 months (includes Sarcha)
final months = calendar.buildMonths(2027);  // 12 months
```

### Resulting Leap Years

**2026, 2029, 2032, 2034, 2037, 2040, 2043, 2045...**

This logic has been stress-tested across a **10,001-year span (2023 to 12023)** with zero critical errors.

## 7. Why Sarcha After Pus Bonga

The 13th month (Sarcha Chando) is always inserted after Pus Bonga (the 12th month) and before Magh Bonga because:

- **New Year Anchor:** The traditional Santali new year begins with Magh Bonga
- **Preventing Seasonal Drift:** The extra 30-day month pushes the upcoming Magh Bonga forward, returning it to its correct seasonal window (late January / early February)
- **Agricultural Idle Time:** Pus falls during Dec–Jan when major agricultural work has concluded and the community is free from major festivals

> "ᱡᱮᱛᱮ ᱪᱟᱸᱫᱚ ᱱᱟᱯᱟᱭ ᱛᱮᱜᱮ ᱪᱟᱞᱟᱜ, ᱯᱩᱥ ᱟᱨ ᱢᱟᱜᱽ ᱜᱮ ᱠᱤᱱ ᱨᱮᱯᱮᱡ ᱵᱟᱲᱟᱜ᱾"
>
> "All months pass smoothly, but it is only Pus and Magh that quarrel with each other." — Guru Gomkey Pt. Raghunath Murmu, _Parsi Poha_

## 8. Continuous Metonic Chain

The engine does **not** rely on Gregorian boundaries (January/February) to find Magh. Instead it uses a Continuous Metonic Chain:

1. Starts from a fixed anchor (Magh 2026 at `2026-01-19`)
2. Counts the exact number of elapsed lunar months since that anchor (12 or 13 per year based on the Metonic cycle position)
3. Steps forward through the New Moon chain by that exact index

This allows Magh to float naturally — sometimes starting in January, sometimes in February after a leap year pushes it late. The months form an unbroken, perfectly aligned continuous chain without ever overlapping or requiring manual correction.

```dart
final calendar = SantaliCalendar();

// Magh start dates float based on leap year position
final magh2026 = calendar.getMonth(2026, 0);
// startDate: 2026-01-19

final magh2027 = calendar.getMonth(2027, 0);
// startDate: 2027-02-07 (pushed later by 2026 leap year)

final magh2029 = calendar.getMonth(2029, 0);
// startDate: 2029-01-28 (another leap year)
```

## 9. Base Year & Chandradarshan

The Santali month does not begin at the exact astronomical New Moon (Amavasya). It begins at **Chandradarshan** (Muluq Etohob) — the first visible sighting of the waxing crescent moon after sunset.

### Cutoff Time: 17:00 IST (5:00 PM)

| Rule   | New Moon Time    | Month Start |
| ------ | ---------------- | ----------- |
| Rule 1 | Before 17:00 IST | Same day    |
| Rule 2 | After 17:00 IST  | Next day    |

**Why 17:00 and not 18:00?** In Eastern India (Jharkhand, Bengal, Odisha), winter sunsets occur between 5:05 PM and 5:15 PM. A 6:00 PM cutoff would incorrectly treat a New Moon at 5:45 PM as "before cutoff" when the sun has already set. 5:00 PM is the scientifically sound safe limit.

The engine uses the **Jean Meeus Astronomical Algorithms** with the J2000.0 epoch (January 6, 2000 at 18:14:00 UTC) — the internationally recognized standard used by NASA and JPL.

---

## References

- [Original Calculation Guide](https://calendar.wesantal.org/docs/calculation-guide)
- [WeSantal Calendar Documentation](https://calendar.wesantal.org/docs)
- [Jean Meeus, _Astronomical Algorithms_](https://www.willbell.com/math/mc1.htm)
