#!/usr/bin/python3

import argparse
import json
import logging
import sys
import os
import subprocess

def parse_args():
    parser = argparse.ArgumentParser(description='Assume an AWS role')

    parser.add_argument('--role-arn', dest='role_arn', type=str, required=True, help='AWS role arn')
    parser.add_argument('--role-session-name', dest='role_session_name', type=str, default='session', help='session name')

    return parser.parse_args()

def setup_log():
    logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)

def clear_env_vars():
    try:
        del os.environ['AWS_ACCESS_KEY_ID']
    except KeyError:
        pass

    try:
        del os.environ['AWS_SECRET_ACCESS_KEY']
    except KeyError:
        pass

    try:
        del os.environ['AWS_SESSION_TOKEN']
    except KeyError:
        pass

def assume_role(role_arn, role_session_name):
    cmd = ['aws', 'sts', 'assume-role', '--role-arn', role_arn, '--role-session-name', role_session_name]
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
        raise RuntimeError('aws cli assume role returned nonzero exit code')

    resp = json.loads(stdout)

    os.environ['AWS_ACCESS_KEY_ID'] = resp['Credentials']['AccessKeyId']
    os.environ['AWS_SECRET_ACCESS_KEY'] = resp['Credentials']['SecretAccessKey']
    os.environ['AWS_SESSION_TOKEN'] = resp['Credentials']['SessionToken']

    logging.debug('Successfully assumed role')

def main():
    args = parse_args()
    setup_log()

    clear_env_vars()
    assume_role(args.role_arn, args.role_session_name)

if __name__ == '__main__':
    main()
