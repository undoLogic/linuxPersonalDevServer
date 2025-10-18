#!/bin/sh

# -- CONFIGURATION --
BW_BIN="./bw"
TARGET_HOST="$1"               # e.g., undoweb@undoweb.com
TMPDIR="/tmp/bw-ssh-keys"
mkdir -p "$TMPDIR"

# -- Ensure SESSION is active --
if [ -z "$BW_SESSION" ]; then
    echo "🔒 BW_SESSION not set. Run ./bw unlock --raw and export it."
    exit 1
fi

# -- Find all items with SSH keys --
echo "🔍 Searching Bitwarden for SSH keys..."
KEY_ITEMS=$($BW_BIN list items --session "$BW_SESSION" | jq -r '.[] | select(.login.sshKey != null) | .id + "|" + .name')

if [ -z "$KEY_ITEMS" ]; then
    echo "❌ No SSH keys found in Bitwarden."
    exit 1
fi

echo "🧪 Trying keys to connect to $TARGET_HOST..."

# -- Try each key in order --
SUCCESS=0
for ITEM in $KEY_ITEMS; do
    ITEM_ID=$(echo "$ITEM" | cut -d '|' -f1)
    ITEM_NAME=$(echo "$ITEM" | cut -d '|' -f2)
    KEY_PATH="$TMPDIR/$ITEM_NAME.key"

    echo "→ Trying key: $ITEM_NAME"

    $BW_BIN get item "$ITEM_ID" --session "$BW_SESSION" | jq -r '.login.sshKey' > "$KEY_PATH"
    chmod 600 "$KEY_PATH"

    # Attempt SSH quietly (no host key checking, useful for script)
    ssh -o BatchMode=yes -o StrictHostKeyChecking=no -i "$KEY_PATH" "$TARGET_HOST" exit

    if [ $? -eq 0 ]; then
        echo "✅ Success with key: $ITEM_NAME"
        SUCCESS=1
        ssh -i "$KEY_PATH" "$TARGET_HOST"
        break
    else
        echo "❌ Failed with key: $ITEM_NAME"
        shred -u "$KEY_PATH"
    fi
done

if [ $SUCCESS -ne 1 ]; then
    echo "❌ All keys failed."
fi
