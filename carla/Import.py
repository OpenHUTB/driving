#!/usr/bin/env python

# Copyright (c) 2019 Computer Vision Center (CVC) at the Universitat Autonoma de
# Barcelona (UAB).
#
# This work is licensed under the terms of the MIT license.
# For a copy, see <https://opensource.org/licenses/MIT>.

"""Import Assets to Carla"""

from __future__ import print_function

import errno
import fnmatch
import glob
import json
import os
import shutil
import subprocess
import sys
import argparse
import threading
import copy


import carla



def build_binary_for_tm():

    f = open('HutbCarlaCity.xodr')
    data = f.read()
    target_name = 'HutbCarlaCity'

    # tm_folder_target = 'D:\work\buffer\carla\Unreal\CarlaUE4\Content\Carla\Maps\HutbCarlaCity'

    m = carla.Map(str(target_name), data)
    m.cook_in_memory_map(str(os.path.join("%s.bin" % target_name)))


def main():
    build_binary_for_tm()

if __name__ == '__main__':
    main()
