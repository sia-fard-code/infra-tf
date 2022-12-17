#!/bin/bash
# Argbash is FREE SOFTWARE, see https://argbash.io for more info
# Generated online by https://argbash.io/generate


die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}


begins_with_short_option()
{
	local first_option all_short_options='caspncbgAwvhi'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_aws_access_key=
_arg_aws_secret_key=
_arg_prod="off"
_arg_non_prod="on"
_arg_common="off"
_arg_blue="off"
_arg_green="off"
_arg_all="on"
_arg_init="on"
_arg_tf_workspace=
_arg_cloud_provider="aws"
env_type="non-prod"
deploy_type="all"
version="1.0"

print_help()
{
	printf '%s\n' "The general script's help msg"
	printf 'Usage: %s [-c|--cloud-provider <arg>] [-a|--aws-access-key <arg>] [-s|--aws-secret-key <arg>] [-p|--(no-)prod] [-n|--(no-)non-prod] [-c|--common] [-b|--blue] [-g|--green] [-A|--all] [-i|--(no-)init] [-w|--tf-workspace <arg>] [-v|--version] [-h|--help]\n' "$0"
	printf '\t%s\n' "-c, --cloud-provider: cloud provider (aws)"
	printf '\t%s\n' "-a, --aws-access-key: aws access key (no default)"
	printf '\t%s\n' "-s, --aws-secret-key: aws secret key (no default)"
	printf '\t%s\n' "-p, --prod, --no-prod: prod env (off by default)"
	printf '\t%s\n' "-n, --non-prod, --no-non-prod: non-prod env (on by default)"
	printf '\t%s\n' "-c, --common, --no-common: common resources (off by default)"
	printf '\t%s\n' "-b, --blue, --no-blue: blue resources (off by default)"
	printf '\t%s\n' "-g, --green, --no-green: green resources (off by default)"
	printf '\t%s\n' "-A, --all, --no-all: all resources (on by default)"
	printf '\t%s\n' "-i, --init, --no-i: init tf (on by default)"
	printf '\t%s\n' "-w, --tf-workspace: tf workspace (no default)"
	printf '\t%s\n' "-v, --version: Prints version"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-c|--cloud-provider)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_cloud_provider="$2"
				shift
				;;
			--cloud-provider=*)
				_arg_cloud_provider="${_key##--cloud-provider=}"
				;;
			-c*)
				_arg_cloud_provider="${_key##-c}"
				;;
			-a|--aws-access-key)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_aws_access_key="$2"
				shift
				;;
			--aws-access-key=*)
				_arg_aws_access_key="${_key##--aws-access-key=}"
				;;
			-a*)
				_arg_aws_access_key="${_key##-a}"
				;;
			-s|--aws-secret-key)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_aws_secret_key="$2"
				shift
				;;
			--aws-secret-key=*)
				_arg_aws_secret_key="${_key##--aws-secret-key=}"
				;;
			-s*)
				_arg_aws_secret_key="${_key##-s}"
				;;
			-p|--no-prod|--prod)
				_arg_prod="on"
                                env_type="prod"
				test "${1:0:5}" = "--no-" && _arg_prod="off" && env_type="non-prod"
				;;
			-p*)
				_arg_prod="on"
                                env_type="prod"
				_next="${_key##-p}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-p" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-i|--no-i|--init)
				_arg_init="on"
				test "${1:0:5}" = "--no-" && _arg_init="off"
				;;
			-i*)
				_arg_init="on"
				_next="${_key##-p}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-i" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;

			-n|--no-non-prod|--non-prod)
				_arg_non_prod="on"
                                env_type="non-prod"
				test "${1:0:5}" = "--no-" && _arg_non_prod="off" && env_type="prod"
				;;
			-n*)
				_arg_non_prod="on"
                                env_type="non-prod"
				_next="${_key##-n}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-n" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-c|--common)
				_arg_common="on"
                                deploy_type="common"
				;;
			-c*)
				_arg_common="on"
                                deploy_type="common"
				_next="${_key##-c}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-c" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-b|--blue)
				_arg_blue="on"
                                deploy_type="blue"
				;;
			-b*)
				_arg_blue="on"
                                deploy_type="blur"
				_next="${_key##-b}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-b" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-g|--green)
				_arg_green="on"
                                deploy_type="green"
				;;
			-g*)
				_arg_green="on"
                                deploy_type="green"
				_next="${_key##-g}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-g" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-A|--all)
				_arg_all="on"
                                deploy_type="all"
				;;
			-A*)
				_arg_all="on"
                                deploy_type="all"
				_next="${_key##-A}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-A" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-w|--tf-workspace)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_tf_workspace="$2"
				shift
				;;
			--tf-workspace=*)
				_arg_tf_workspace="${_key##--tf-workspace=}"
				;;
			-w*)
				_arg_tf_workspace="${_key##-w}"
				;;
			-v|--version)
				echo test v$version
				exit 0
				;;
			-v*)
				echo test v$version
				exit 0
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}

parse_commandline "$@"

init_backend() {
  if [[ ${_arg_init} == "on" ]]; then
    rm -fr $1/.terraform
    terraform -chdir=$1 init -backend-config="region=us-west-2" -backend-config="access_key=${_arg_aws_access_key}" -backend-config="secret_key=${_arg_aws_secret_key}"  -backend-config="workspace_key_prefix=${_arg_cloud_provider}" -backend-config="bucket=com.masimo.msn.tf.${env_type}" -backend-config="dynamodb_table=com.masimo.msn.tf.${env_type}" -backend-config="key=$1.tfstate" -upgrade
  fi
  terraform -chdir=$1 workspace list
  if [[ ${_arg_tf_workspace} != "" ]]; then
        terraform -chdir=$1 workspace select ${_arg_tf_workspace}
  fi
}

if [[ $deploy_type == "all" ]]; then
  init_backend "common"
  init_backend "blue"
  init_backend "green"
else
  init_backend $deploy_type
fi