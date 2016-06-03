from pymongo import MongoClient
import json
import sys
reload(sys)
sys.setdefaultencoding("utf-8")
#uri = "mongodb://localhost"
uri = "mongodb://mongodb-1-server-1:27017,mongodb-1-server-2:27017/plate?replicaSet=rs0&connectTimeoutMS=3000&readPreference=secondaryPreferred"                    
 
client = MongoClient(uri)
db = client['plate']
collections = db['imagecollections']
images_db = db['images']
candidates = []
for temp_images in collections.find():
    collection = temp_images['collectionName']
    for image in temp_images['images']:
        iptc = image['iptc']
        image_obj = {'_id': image['_id'], 'image': image}
        if ('caption' in iptc):
            image_obj['description'] = iptc['caption']
        if ('keywords' in iptc):
            image_obj['keywords'] = iptc['keywords']
        candidates.append(image_obj)
    images_db.insert_many(candidates)
    delete_count = collections.delete_one({'collectionName': collection})
    candidates = []
