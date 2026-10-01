#!/bin/bash
# Links ~/.config/htop/htoprc to the config matching the installed htop version
# (or the closest available one). Portable: works with bash 3.2 (macOS) and BSD/GNU coreutils.

HTOP_DEFAULT_VERSION="1.0.3"
HTOP_CFG_DIR="$HOME/.config/htop"
HTOP_VERSION=$( htop --version 2>/dev/null | grep "^htop" | awk '{print $2}' )

cd "$HTOP_CFG_DIR/" || { echo "ERROR: failed change dir to $HTOP_CFG_DIR/" 1>&2; exit 1; }

# available config versions (htoprc-X.Y.Z -> X.Y.Z), broken symlinks included
AVAILABLE=()
for file in htoprc-*; do
    [[ -e $file || -L $file ]] || continue
    AVAILABLE+=("${file#htoprc-}")
done
if [[ ${#AVAILABLE[@]} -eq 0 ]]; then
    echo "ERROR: no htoprc-* config files found in $HTOP_CFG_DIR/" 1>&2
    exit 1
fi

# returns 0 if version $1 < version $2 (numeric compare of dot-separated parts, pure bash)
version_lt(){
    local IFS=.
    local a=($1) b=($2) i count pa pb
    count=$(( ${#a[@]} > ${#b[@]} ? ${#a[@]} : ${#b[@]} ))
    for (( i = 0; i < count; i++ )); do
        pa=${a[i]//[^0-9]/}; pb=${b[i]//[^0-9]/}
        (( 10#${pa:-0} < 10#${pb:-0} )) && return 0
        (( 10#${pa:-0} > 10#${pb:-0} )) && return 1
    done
    return 1
}

# pick the closest available config version for the given htop version:
#   1. exact match
#   2. same major version: highest version below, else lowest version above
#   3. any major version:  highest version below, else lowest version above
pick_version(){
    local current="$1" major="${1%%.*}"
    local lower="" higher="" same_lower="" same_higher="" candidate version
    for version in "${AVAILABLE[@]}"; do
        if [[ $version == "$current" ]]; then
            echo "$version"
            return
        fi
        if version_lt "$version" "$current"; then
            if [[ -z $lower ]] || version_lt "$lower" "$version"; then
                lower="$version"
            fi
            if [[ ${version%%.*} == "$major" ]]; then
                if [[ -z $same_lower ]] || version_lt "$same_lower" "$version"; then
                    same_lower="$version"
                fi
            fi
        else
            if [[ -z $higher ]] || version_lt "$version" "$higher"; then
                higher="$version"
            fi
            if [[ ${version%%.*} == "$major" ]]; then
                if [[ -z $same_higher ]] || version_lt "$version" "$same_higher"; then
                    same_higher="$version"
                fi
            fi
        fi
    done
    for candidate in "$same_lower" "$same_higher" "$lower" "$higher"; do
        if [[ -n $candidate ]]; then
            echo "$candidate"
            return
        fi
    done
}

if [[ -z $HTOP_VERSION ]]; then
    echo "WARNING: failed to detect htop version, using default $HTOP_DEFAULT_VERSION" 1>&2
    HTOP_VERSION="$HTOP_DEFAULT_VERSION"
fi

TARGET_VERSION=$( pick_version "$HTOP_VERSION" )
if [[ -z $TARGET_VERSION ]]; then
    echo "ERROR: failed to pick config for htop $HTOP_VERSION in $HTOP_CFG_DIR/" 1>&2
    exit 1
fi
if [[ $TARGET_VERSION != "$HTOP_VERSION" ]]; then
    echo "INFO: no config for htop $HTOP_VERSION, using closest htoprc-$TARGET_VERSION"
fi

# short flags on purpose: BSD ln (macOS) has no long options
# -s symbolic, -f replace existing, -n do not follow an existing symlink
ln -sfn "htoprc-$TARGET_VERSION" htoprc
