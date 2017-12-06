import os
import os.path as path
import sys
import hashlib
import io
import json


if len(sys.argv) < 2:
    print 'No version!'
    sys.exit()

print 'appname-appId:', sys.argv[4], sys.argv[3]

appname = sys.argv[4]

version = sys.argv[1]
dirRoot = sys.argv[5]
print 'version:', version

#download_url = '114.55.37.226'
#download_url = sys.argv[2]
download_url = 'app.wangwang68.com'
package_url = 'http://' + download_url + ':8000/' + appname + '/files/'
print 'package_url:', package_url
remote_version_url = 'http://' + download_url + ':8000/' + appname + '/version/version.manifest'
print 'remote_version_url:', remote_version_url
remote_manifest_url = 'http://' + download_url + ':8000/' + appname + '/version/project.manifest'
print 'remote_manifest_url:', remote_manifest_url
engine_version = 'wangwanggame2017'
print 'engine_version:', engine_version

rootdir = path.abspath(path.join(sys.path[0], dirRoot+ '/' + appname +'/files'))
print 'root dir:', rootdir
srcdir = path.join(rootdir, 'src')
print 'src dir:', srcdir
resdir = path.join(rootdir, 'res')
print 'res dir:', resdir
version_manifest = path.join(rootdir, '../version', 'version.manifest')
print 'version_manifest:', version_manifest
project_manifest = path.join(rootdir, '../version', 'project.manifest')
print 'project_manifest:', project_manifest

def md5_file(path):
    m = hashlib.md5()
    file = io.FileIO(path, 'rb')
    byte = file.read(1024)
    while byte :
        m.update(byte)
        byte = file.read(1024)
    file.close()
    md5_value = m.hexdigest()
    # print path, md5_value
    return md5_value


def main():
    
    data = { 
        'packageUrl':package_url,
        'remoteVersionUrl':remote_version_url,
        'remoteManifestUrl':remote_manifest_url,
        'version':version,
        'engineVersion':engine_version,
    }

    # version.manifest
    file = io.FileIO(version_manifest, 'w')
    json_data = json.dumps(data, skipkeys=True, ensure_ascii=False, indent=4, separators=(',', ' : '), sort_keys=True)
    file.write(json_data)
    file.close()

    # traverse src and res directory
    data['assets'] = assets = {}
    def walk(dir):
        count = 0
        for parent, dirs, files in os.walk(dir):
            # if parent.find('src/cocos') >= 0 or parent.find('src/framework') >= 0:
            #     continue

            for name in files:
                if name.startswith('.'):
                    continue
                md5_value = md5_file(path.join(parent, name))
                relpath = path.relpath(path.join(parent, name), rootdir)
                assets[relpath] = { 'md5':md5_value }

                count = count + 1

        return count

    count = 0
    count += walk(srcdir)
    count += walk(resdir)

    # project.manifest
    file = io.FileIO(project_manifest, 'w')
    json_data = json.dumps(data, skipkeys=True, ensure_ascii=False, indent=4, separators=(',', ' : '), sort_keys=True)
    file.write(json_data)
    file.close()

    print "Completed! md5 files number: ", count


main()