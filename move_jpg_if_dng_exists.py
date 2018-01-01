#!/usr/bin/python
import os
import shutil

raw_ext = '.dng'
jpg_ext = '.JPG'
destination = '/Users/kulhanek/Downloads/jpgs/'

for filename in os.listdir('.'):
    (shortname, extension) = os.path.splitext(filename)

    if extension == raw_ext:
        if os.path.isfile(shortname + jpg_ext):
            print 'Moving ' + shortname + jpg_ext + '...'
            shutil.move(shortname + jpg_ext, destination)

