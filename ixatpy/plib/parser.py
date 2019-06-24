from html.parser import HTMLParser

class Parser(HTMLParser):
    def handle_startendtag(self, tag, attrs):
        self.tag = tag
        self.attrib = {}
        for attr in attrs:
        	self.attrib[attr[0]] = attr[1]