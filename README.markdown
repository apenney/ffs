Facter For Structured Data
==========================

AKA

Facter From Scratch
===================

AKA

For F$!ks Sake
==============

- - -


Facter prototypes for structured data.

Branches:

#### master

Shared code between implementations. Nothing interesting.

#### single-resolution-multiple-actions

Resolutions and weight act the same, but can have multiple blocks defined with
dependencies listed so that data can be redefined and extended.

This approach makes the underlying code more complex, but plays well with
existing facts and the general Facter architecture.

#### multiple-resolutions

Resolutions can invoke other resolutions and modify the given value. The
resolution with the highest weight that was defined first is the one that's used
by default.

This approach makes the underlying code a bit more simple, but it interacts
poorly with the weighting system.

If multiple resolutions with the same weight are defined, only the first one
would be used. This would exclude all but one extension.

If multiple resolutions with the same weight are all loaded, this excludes
valid resolutions that might have a lower weight, and makes it hard to override
resolutions without explicitly invoking all lower weight resolutions.

If all suitable resolutions are invoked, fallback resolutions are always
invoked.
