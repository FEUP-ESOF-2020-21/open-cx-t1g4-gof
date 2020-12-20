class Talk:

    def __init__(self, d):
        self.q = d

    @property
    def description(self):
        return self.q[u'description']
    
    @property
    def speaker(self):
        return self.q[u'speaker']

    @property
    def startDate(self):
        return self.q[u'startDate']

    @property
    def title(self):
        return self.q[u'title']
    
    @property
    def tags(self):
        return self.q[u'tags']

    @staticmethod
    def fromInfo(cls, self, description, speaker, startDate, title, tags):
        return Talk({
            u'description': description,
            u'speaker': speaker,
            u'startDate': startDate,
            u'title': title,
            u'tags': tags,
        })
