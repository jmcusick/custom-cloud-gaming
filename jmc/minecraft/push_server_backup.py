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
    parser.add_argument('--exclude-list', dest='exclude_list', type=str, action='append', default=['logs','server.jar','eula.txt', '*.log', 'crash_reports'], help='Items to exclude from server backup')
    parser.add_argument('--s3-bucket', dest='s3_bucket', type=str, required=True, help='AWS S3 bucket for server backup')
    parser.add_argument('--s3-object', dest='s3_object', type=str, required=True, help='Name of server backup file')

    return parser.parse_args()

def setup_log():
    logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)

def tar_compress_world(server_folder, exclude_list, output_file):
    cmd_start = ['tar', '-zcvf', output_file]
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
        raise RuntimeError('tar compression returned nonzero exit code')

    logging.debug(stdout)


def s3_push(server_tar_file, s3_bucket, s3_object):
    cmd = ['aws', 's3', 'cp', server_tar_file, 's3://{}/{}'.format(s3_bucket, s3_object)]
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

    logging.debug('Backing up {} to bucket {} object {}...'.format(
        args.server_folder,
        args.s3_bucket,
        args.s3_object
    ))

    clear_env_vars()
    assume_role(args.role_arn, args.role_session_name)

    now = datetime.now()
    dt_str = now.strftime("%Y%m%d_%H%M%S")
    server_tar_file = os.path.join(os.environ['HOME'], 'backups', 'backup_{}.tar.gz'.format(dt_str))

    tar_compress_world(args.server_folder, args.exclude_list, server_tar_file)

    s3_push(server_tar_file, args.s3_bucket, args.s3_object)

    logging.debug('Backup complete.')

if __name__ == '__main__':
    main()
