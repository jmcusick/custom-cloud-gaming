#!/usr/bin/python3

import argparse
import logging
import sys
import subprocess
import os

from datetime import datetime

from jmc.aws.assume_role import clear_env_vars, assume_role

def parse_args():
    parser = argparse.ArgumentParser(description='Assume an AWS role')

    parser.add_argument('--role-arn', dest='role_arn', type=str, required=True, help='AWS role arn')
    parser.add_argument('--role-session-name', dest='role_session_name', type=str, default='session', help='AWS session name')
    parser.add_argument('--server-folder', dest='server_folder', type=str, required=True, help='Minecraft server folder')
    parser.add_argument('--exclude-list', dest='exclude_list', type=str, action='append', default=['logs','server.jar','eula.txt'], help='Items to exclude from server backup')
    parser.add_argument('--s3-bucket', dest='s3_bucket', type=str, required=True, help='AWS S3 bucket for server backup')
    parser.add_argument('--s3-object', dest='s3_object', type=str, required=True, help='Name of server backup file')
    parser.add_argument('--version-id', dest='version_id', type=str, help='Server version to pull')

    return parser.parse_args()

def setup_log():
    logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)

def tar_extract_world(input_file, exclude_list, server_folder):
    cmd_start = ['tar', '-zxvf', input_file]
    cmd_exclude = ['--exclude="{}"'.format(item) for item in exclude_list]
    cmd_end = [server_folder]

    cmd = cmd_start + cmd_exclude + cmd_end
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
        raise RuntimeError('tar extraction returned nonzero exit code')

    logging.debug(stdout)


def s3_pull(s3_bucket, s3_object, server_tar_file, version_id):
    cmd = ['aws', 's3', 'cp', 's3://{}/{}'.format(s3_bucket, s3_object), server_tar_file]
    if version_id:
        cmd = ['aws', 's3api', 'get-object', '--bucket', s3_bucket, '--key', s3_object, '--version-id', version_id, server_tar_file]

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
        raise RuntimeError('aws cli s3 download returned nonzero exit code')

    logging.debug(stdout)

def main():
    args = parse_args()
    setup_log()

    clear_env_vars()
    assume_role(args.role_arn, args.role_session_name)

    now = datetime.now()
    dt_str = now.strftime("%Y%m%d_%H%M%S")
    server_tar_file = os.path.join(os.environ['HOME'], 'downloads', 'backup_{}.tar.gz'.format(dt_str))

    s3_pull(args.s3_bucket, args.s3_object, server_tar_file, args.version_id)

    tar_extract_world(server_tar_file, args.exclude_list, args.server_folder)

if __name__ == '__main__':
    main()
