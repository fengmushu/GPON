# -*- coding: utf-8 -*-

import subprocess
from log import logger


def set(width, height):
    support_resolution = [
        (800,  480),
        (1024, 768),
        (1280, 1024),
        (1280, 720),
        (1366, 768),
        (1440, 900),
        (1600, 900),
        (1680, 1050),
        (1920, 1080),
        (2048, 1536)
    ]

    if (int(width), int(height)) not in support_resolution:
        logger.error('not support resolution: ' + str(width) + 'x' + str(height))
        return False

    if str(width) == '1920':
        ret = subprocess.call(['h3disp', '-m', '1080p60'])
    elif str(height) == '720':
        ret = subprocess.call(['h3disp', '-m', '720p60'])
    else:
        ret = subprocess.call(['h3disp', '-m', str(width) + 'x' + str(height)])

    logger.info('set screen resolution result: ' + str(ret))

    return ret == 0
