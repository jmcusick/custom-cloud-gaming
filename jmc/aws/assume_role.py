import json
import logging
import os
import subprocess

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
