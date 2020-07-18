#!/usr/bin/python3

import argparse
import urllib.request
import json
import logging
import sys
import os

version_manifest_url = 'https://launchermeta.mojang.com/mc/game/version_manifest.json'
jar_directory = '/home/minecraft/minecraft_server_jars'
latest_jar_filename = 'minecraft_server_latest.jar'

def parse_args():
    parser = argparse.ArgumentParser(description='update a Minecraft server')
    return parser.parse_args()

def setup_log():
    logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)

def get_json_from_url(json_url):
    with urllib.request.urlopen(json_url) as url:
        return json.loads(url.read())

def get_version_manifest():
    return get_json_from_url(version_manifest_url)

def get_server_jar(snapshot_url, jar_file_path):
    snapshot = get_json_from_url(snapshot_url)
    jar_url = snapshot['downloads']['server']['url']
    urllib.request.urlretrieve(jar_url, jar_file_path)

def update_latest_jar_symlink(jar_file_path):
    latest_jar_file_path = os.path.join(jar_directory, latest_jar_filename)
    # work around to overwrite any existing symlink (see https://stackoverflow.com/a27788271)
    os.symlink(jar_file_path, latest_jar_file_path + '.tmp')
    os.replace(latest_jar_file_path + '.tmp', latest_jar_file_path)

def main():
    args = parse_args()
    setup_log()

    version_manifest = get_version_manifest()

    latest_release_id = version_manifest['latest']['release']

    latest_release = []
    for snapshot in version_manifest['versions']:
        if snapshot['id'] == latest_release_id:
            latest_release = snapshot
            break

    if not latest_release:
        logging.error('Could not find latest release {} in the version manifest'.format(latest_release_id))
        return 1

    logging.debug('latest release: {}'.format(latest_release['id']))
    logging.debug('latest release url: {}'.format(latest_release['url']))

    jar_filename = 'minecraft_server_{}.jar'.format(latest_release['id'])
    jar_file_path = os.path.join(jar_directory, jar_filename)

    if os.path.exists(jar_file_path):
        logging.debug('Already have latest Minecraft server located at {}'.format(jar_file_path))
        return 0

    get_server_jar(latest_release['url'], jar_file_path)
    update_latest_jar_symlink(jar_file_path)

    logging.debug('successfully updated minecraft server, latest jar located at {}'.format(jar_file_path))

if __name__ == '__main__':
    main()
