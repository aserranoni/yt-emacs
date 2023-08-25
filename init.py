
from youtubesearchpython import VideosSearch
import argparse
import json

parser = argparse.ArgumentParser()
parser.add_argument("query")
parser.add_argument("n_videos", type=int)
args = parser.parse_args()


videosSearch = VideosSearch(args.query, limit = args.n_videos)

print(json.dumps(videosSearch.result()))
