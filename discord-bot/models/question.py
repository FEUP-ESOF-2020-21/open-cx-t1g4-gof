class Question:

    def __init__(self, content, authorDisplayName, authorID, timestamp):
        self.q = {
            u'content': content,
            u'authorDisplayName': authorDisplayName,
            u'authorID': authorID,
            u'authorPlatform': 'Discord',
            u'postDate': timestamp,
            u'avgRating': 2.5,
            u'totalRatings': 0
        }
