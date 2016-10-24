import sys
import os
import json
import re

from nltk.corpus import stopwords

def unescape_string(string):
    #print "Processing :", string
    try:
        string = string.replace('\\n', '')
        processed_string = string
        #processed_string = json.loads('"' + string + '"')
        return processed_string
    except Exception:
        pass
    return string 

def main():
    if len(sys.argv) == 0:
        print 'Usage python ', s.path.basename(__file__), 'filename'
        exit
    
    print 'Processing', sys.argv[1]
    
    # read from file
    f = open(sys.argv[1], 'r')
    tweet_file = open('../data/tweets.txt', 'w')
    filtered_tweet_file = open('../data/filtered_tweets.txt', 'w')
    hashtag_pairs = open('../data/hash_pair.tsv', 'w')
    for line in f:
       #first extract tweets and hashtags
       line = line.lower()
       line_split = line.split('*,,,*')
       filtered_words = filter(lambda x: x not in stopwords.words('english') and not re.search('^#.*|http(s)*:.*', x), line_split[2].split(' ')) 

       tweet_file.write(line_split[2] + '\n')
       filtered_tweet_file.write(' '.join(filtered_words) + '\n')
      
       #create word tweet pairs
       hashtags = filter(lambda x: len(x) > 0, line_split[5].strip().split('*;*'));
       
       #process words and hashtags
       hashtags = [unescape_string(x) for x in hashtags]
       words = [unescape_string(x) for x in filtered_words]     

       if len(hashtags) > 1:
           for word in filtered_words:
               word = unescape_string(word) 
               if(len(word) > 0): 
                   for hashtag in hashtags:
                       if(len(hashtag) > 0):
                           pair = hashtag + "\t" + word 
                           #print pair
                           hashtag_pairs.write(pair + '\n')   

main() 
