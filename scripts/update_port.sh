#!/bin/bash
#set -x
PORT=$1

[ "$PORT" == "" ] && echo "empty port name" && exit 1
git add ports/"$PORT" && git commit -m "update $PORT"
GIT_TREE=$(git rev-parse HEAD:ports/"$PORT")
VERSION_FILE=$(ls versions/*/"$PORT".json)

if [ "$(uname)" == "Darwin" ]; then
    sed -i '' -E "s/\"git-tree\": \"[0-9a-z]+\"/\"git-tree\": \"${GIT_TREE}\"/" "$VERSION_FILE"
else
    sed -i "s/\"git-tree\": \"[0-9a-z]+\"/\"git-tree\": \"${GIT_TREE}\"/" "$VERSION_FILE"
fi

git add versions && git commit -m "update git-tree for port $PORT"
