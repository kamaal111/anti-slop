set -e

if [ -z "$VERSION" ]; then
  echo "❌ Error: VERSION environment variable is not set"
  echo "Usage: VERSION=x.x.x pnpm run release"
  exit 1
fi

if [ "${GITHUB_ACTIONS:-}" != "true" ] \
  || [ -z "${ACTIONS_ID_TOKEN_REQUEST_URL:-}" ] \
  || [ -z "${ACTIONS_ID_TOKEN_REQUEST_TOKEN:-}" ]
then
  echo "❌ This package may only be published by the GitHub Actions release workflow"
  echo "Create and push the release tag instead: git tag $VERSION && git push origin $VERSION"
  exit 1
fi

npm --force version "$VERSION" --no-git-tag-version --allow-same-version
pnpm check
npm --force publish --access public --no-git-checks
