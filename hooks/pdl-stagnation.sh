#!/bin/bash
# PDL lifecycle hook — stagnation detected
#
# Fires when two consecutive rounds have |delta| < 0.2. Stdin is JSON:
#   { "round": 4, "score": 8.9, "best": 8.9, "rounds_remaining": 2 }
#
# Exit codes:
#   0  accept stagnation (conductor exits STAGNATED)
#   2  force APPROVED with the current best score (manual accept)
#   3  escalate — conductor prompts user for manual tweaks
#
# This is a stub. Customize to match your stagnation policy.

exit 0
