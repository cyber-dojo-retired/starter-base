#!/bin/bash

test_repeated_long_options()
{
  make_TMP_DIR_for_git_repos
  local C1_TMP_URL=$(git_repo_url_in_TMP_DIR_from custom-tennis)
  local C2_TMP_URL=$(git_repo_url_in_TMP_DIR_from custom-yahtzee)
  local E1_TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises-bowling-game)
  local E2_TMP_URL=$(git_repo_url_in_TMP_DIR_from exercises-tiny-maze)
  local L1_TMP_URL=$(git_repo_url_in_TMP_DIR_from ltf-csharp-nunit)
  local L2_TMP_URL=$(git_repo_url_in_TMP_DIR_from ltf-ruby-minitest)

  local image_name="${FUNCNAME[0]}"
  build_start_points_image        \
    "${image_name}"               \
      --custom    "${C1_TMP_URL}" \
      --custom    "${C2_TMP_URL}" \
      --exercises "${E1_TMP_URL}" \
      --exercises "${E2_TMP_URL}" \
      --languages "${L1_TMP_URL}" \
      --languages "${L2_TMP_URL}"

  assert_image_created
  assert_stderr_equals ''
  assert_status_equals 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
