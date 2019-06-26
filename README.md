
<img src="https://raw.githubusercontent.com/cyber-dojo/nginx/master/images/home_page_logo.png" alt="cyber-dojo yin/yang logo" width="50px" height="50px"/>

[![CircleCI](https://circleci.com/gh/cyber-dojo/starter-base.svg?style=svg)](https://circleci.com/gh/cyber-dojo/starter-base)

The source for the [cyberdojo/starter-base](https://hub.docker.com/r/cyberdojo/starter-base) docker image.

## The build script
* Use the [cyber-dojo](https://github.com/cyber-dojo/commander/blob/master/cyber-dojo)
script to create your own start-point images.
* It will use [cyberdojo/starter-base](https://hub.docker.com/r/cyberdojo/starter-base) as its base (FROM) image.

```bash
$ ./cyber-dojo start-point create --help
  Use:
  cyber-dojo start-point create <name> --custom    <url> ...
  cyber-dojo start-point create <name> --exercises <url> ...
  cyber-dojo start-point create <name> --languages <url> ...
  ...
```
For example:
```bash
$ ./cyber-dojo start-point create \
      acme/my-languages-start-points \
        --languages \
          https://github.com/cyber-dojo-languages/csharp-nunit             \
          https://github.com/cyber-dojo-languages/gplusplus-googlemock.git \
          https://github.com/cyber-dojo-languages/java-junit.git

--languages      https://github.com/cyber-dojo-languages/csharp-nunit
--languages      https://github.com/cyber-dojo-languages/gplusplus-googlemock.git
--languages      https://github.com/cyber-dojo-languages/java-junit.git
Successfully built acme/my-languages-start-points
```

- - - -

## git-repo-url format
There are 2 kinds of start-points
- languages/custom. These are specified with full [manifest.json](https://blog.cyber-dojo.org/2016/08/cyber-dojo-start-points-manifestjson.html) files.
- exercises. These are specified with a subset of the languages/custom manifest.json files and have only two entries:
  - You must specify a display_name
  - You must specify the visible_filenames
  - visible_filenames cannot contain a file called cyber-dojo.sh

- - - -

## micro-service API
- A docker-containerized micro-service for [cyber-dojo](http://cyber-dojo.org).
- Holds the start-points used when setting up a practice session.

API:
  * All methods receive their named arguments in a json hash.
  * All methods return a json hash.
    * If the method completes, a key equals the method's name.
    * If the method raises an exception, a key equals "exception".

#
- [GET ready?()](#get-ready)
- [GET sha()](#get-sha)
#
- [GET names()](#get-names)
- [GET manifests()](#get-manifests)
- [GET manifest(name)](#get-manifestname)

- - - -

### GET ready?()
- parameters, none
```
  {}
```
- returns true if the service is ready, otherwise false, eg
```
  { "ready?": true }
  { "ready?": false }
```

- - - -

### GET sha()
Returns the git commit sha used to create the docker image.
- parameters, none
```
  {}
```
- returns the sha, eg
```
  { "sha": "b28b3e13c0778fe409a50d23628f631f87920ce5" }
```

- - - -

### GET names()
- parameters, none
```
  {}
```
- returns a sorted array of the display_names from all manifests, eg
```
  { "names": [
      "C (gcc), assert",
      "C#, NUnit",
      "C++ (g++), assert",
      "Python, py.test",
      "Python, unittest"
    ]
  }
```

- - - -

### GET manifests()

- - - -

### GET manifest(name)
- parameters, name from a previous call to the names method above, eg
```
  {  "name": "C#, NUnit" }
```
- returns the manifest for the given name, eg
```
  { "manifest": {
      "display_name": "C#, NUNit",
      "image_name": "cyberdojofoundation/csharp_nunit",
      "filename_extension": [ ".cs" ],
      "visible_files": {
        "Hiker.cs": {               
          "content" => "public class Hiker..."
        },
        "HikerTest.cs": {
          "content" => "using NUnit.Framework;..."
        },
        "cyber-dojo.sh": {
          "content" => "NUNIT_PATH=/nunit/lib/net45..."
        }
      }
    }
  }
```

- - - -

* [Take me to cyber-dojo's home github repo](https://github.com/cyber-dojo/cyber-dojo).
* [Take me to the http://cyber-dojo.org site](http://cyber-dojo.org).

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
