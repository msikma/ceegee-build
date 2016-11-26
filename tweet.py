#!/usr/bin/env python3
from twitter import *
import sys
import argparse

# Save the path to this script in a Bash variable named CEEGEE_TWTR_SCRIPT.
# Invocation example for Bash:
# $ ./tweet.py --url="http://asdf.com/" --count="108" --branch="master" --hash="hash" --atoken="$CEEGEE_TWTR_A_T" --asecret="$CEEGEE_TWTR_A_S" --ctoken="$CEEGEE_TWTR_C_T" --csecret="$CEEGEE_TWTR_C_S"

parser = argparse.ArgumentParser()
parser.add_argument('--url', help='URL to the new build')
parser.add_argument('--count', help='Build number (number of commits in the branch)')
parser.add_argument('--branch', help='Branch name')
parser.add_argument('--hash', help='Short hash of the latest commit')
parser.add_argument('--atoken', help='Twitter app access token')
parser.add_argument('--asecret', help='Twitter app access secret')
parser.add_argument('--ctoken', help='Twitter app consumer token')
parser.add_argument('--csecret', help='Twitter app consumer secret')
args = parser.parse_args()

if args.url is None \
   or args.count is None \
   or args.branch is None \
   or args.hash is None \
   or args.atoken is None \
   or args.asecret is None \
   or args.ctoken is None \
   or args.csecret is None:
    parser.error('insufficient arguments')
    sys.exit(0)

text = 'New CeeGee build is up: build {} ({} branch; {}) {}'.format(
  args.count, args.branch, args.hash, args.url
)

twitter = Twitter(auth=OAuth(
	  args.atoken,
	  args.asecret,
	  args.ctoken,
	  args.csecret
))
results = twitter.statuses.update(status=text)
print('Posted status: %s' % text)