#!/bin/sh
set -eu
mkdir -p fixture
printf '%s\n' 'export function retries(value) { return value || 10; }' > fixture/retries.js
