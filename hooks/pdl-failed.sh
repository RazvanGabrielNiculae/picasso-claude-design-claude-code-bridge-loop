#!/bin/bash
# PDL lifecycle hook — failed
#
# Fires when rounds are exhausted without meeting the gate, or the loop
# exits STAGNATED. Stdin is JSON:
#   { "reason": "EXHAUSTED|STAGNATED|BLOCKED|ERROR",
#     "best_score": 8.4, "best_round": 3, "artifacts_dir": ".pdl" }
#
# Typical uses: notify the user, open a fallback ticket, archive the
# artifacts for manual review.
#
# Exit codes: always 0 — informational only.
#
# This is a stub. Customize as needed.

exit 0
