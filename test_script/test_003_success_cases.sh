#!/bin/bash
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh

test_003a_simple_success_case()
{
  local image_name="${FUNCNAME[0]}"
  git_repo_tmp_dir=$(make_tmp_dir_for_git_repos)

  create_git_repo_from_named_data_set good_custom
  create_git_repo_from_named_data_set good_exercises
  create_git_repo_from_named_data_set good_languages

  build_start_points_image \
    "${image_name}"  \
      --custom    "file://${git_repo_tmp_dir}/good_custom"    \
      --exercises "file://${git_repo_tmp_dir}/good_exercises" \
      --languages "file://${git_repo_tmp_dir}/good_languages"

  assert_stdout_includes $(echo -e "--custom \t file://${git_repo_tmp_dir}/good_custom")
  assert_stdout_includes $(echo -e "--exercises \t file://${git_repo_tmp_dir}/good_exercises")
  assert_stdout_includes $(echo -e "--languages \t file://${git_repo_tmp_dir}/good_languages")
  assert_stdout_line_count_equals 3

  assert_stderr_equals ''
  assert_status_equals 0
  assert_image_created "${image_name}"
  docker image rm "${image_name}" > /dev/null
}

. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
