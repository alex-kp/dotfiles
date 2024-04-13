#!/bin/bash

# https://brad-x.com/posts/quick-tip-setting-the-color-space-value-in-wayland/

proptest -M i915 -D /dev/dri/card0 113 connector 99 1
proptest -M i915 -D /dev/dri/card0 119 connector 99 1
