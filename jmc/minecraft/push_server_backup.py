#!/usr/bin/python3

import argparse
import logging
import sys
import subprocess

from jmc.aws.assume_role import clear_env_vars, assume_role

def parse_args():
    parser = argparse.ArgumentParser(description='Assume an AWS role')

    parser.add_argument('--role-arn', dest='role_arn', type=str, required=True, help='AWS role arn')
    parser.add_argument('--role-session-name', dest='role_session_name', type=str, default='session', help='session name')

    return parser.parse_args()

def setup_log():
    logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)

def s3_push():
    cmd = ['echo', '$AWS_ACCESS_KEY_ID']
    logging.debug('Executing cmd: {}'.format(' '.join(cmd)))
    process = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )

    stdout, stderr = process.communicate()
    rc = process.returncode

    if rc != 0:
        logging.error(stderr)
        raise RuntimeError('aws cli s3 upload returned nonzero exit code')

    logging.debug(stdout)

def main():
    args = parse_args()
    setup_log()

    clear_env_vars()
    assume_role(args.role_arn, args.role_session_name)

    s3_push



if __name__ == '__main__':
    main()
