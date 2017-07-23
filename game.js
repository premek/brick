
var Module;

if (typeof Module === 'undefined') Module = eval('(function() { try { return Module || {} } catch(e) { return {} } })()');

if (!Module.expectedDataFileDownloads) {
  Module.expectedDataFileDownloads = 0;
  Module.finishedDataFileDownloads = 0;
}
Module.expectedDataFileDownloads++;
(function() {
 var loadPackage = function(metadata) {

    var PACKAGE_PATH;
    if (typeof window === 'object') {
      PACKAGE_PATH = window['encodeURIComponent'](window.location.pathname.toString().substring(0, window.location.pathname.toString().lastIndexOf('/')) + '/');
    } else if (typeof location !== 'undefined') {
      // worker
      PACKAGE_PATH = encodeURIComponent(location.pathname.toString().substring(0, location.pathname.toString().lastIndexOf('/')) + '/');
    } else {
      throw 'using preloaded data can only be done on a web page or in a web worker';
    }
    var PACKAGE_NAME = 'game.data';
    var REMOTE_PACKAGE_BASE = 'game.data';
    if (typeof Module['locateFilePackage'] === 'function' && !Module['locateFile']) {
      Module['locateFile'] = Module['locateFilePackage'];
      Module.printErr('warning: you defined Module.locateFilePackage, that has been renamed to Module.locateFile (using your locateFilePackage for now)');
    }
    var REMOTE_PACKAGE_NAME = typeof Module['locateFile'] === 'function' ?
                              Module['locateFile'](REMOTE_PACKAGE_BASE) :
                              ((Module['filePackagePrefixURL'] || '') + REMOTE_PACKAGE_BASE);
  
    var REMOTE_PACKAGE_SIZE = metadata.remote_package_size;
    var PACKAGE_UUID = metadata.package_uuid;
  
    function fetchRemotePackage(packageName, packageSize, callback, errback) {
      var xhr = new XMLHttpRequest();
      xhr.open('GET', packageName, true);
      xhr.responseType = 'arraybuffer';
      xhr.onprogress = function(event) {
        var url = packageName;
        var size = packageSize;
        if (event.total) size = event.total;
        if (event.loaded) {
          if (!xhr.addedTotal) {
            xhr.addedTotal = true;
            if (!Module.dataFileDownloads) Module.dataFileDownloads = {};
            Module.dataFileDownloads[url] = {
              loaded: event.loaded,
              total: size
            };
          } else {
            Module.dataFileDownloads[url].loaded = event.loaded;
          }
          var total = 0;
          var loaded = 0;
          var num = 0;
          for (var download in Module.dataFileDownloads) {
          var data = Module.dataFileDownloads[download];
            total += data.total;
            loaded += data.loaded;
            num++;
          }
          total = Math.ceil(total * Module.expectedDataFileDownloads/num);
          if (Module['setStatus']) Module['setStatus']('Downloading data... (' + loaded + '/' + total + ')');
        } else if (!Module.dataFileDownloads) {
          if (Module['setStatus']) Module['setStatus']('Downloading data...');
        }
      };
      xhr.onload = function(event) {
        var packageData = xhr.response;
        callback(packageData);
      };
      xhr.send(null);
    };

    function handleError(error) {
      console.error('package error:', error);
    };
  
      var fetched = null, fetchedCallback = null;
      fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE, function(data) {
        if (fetchedCallback) {
          fetchedCallback(data);
          fetchedCallback = null;
        } else {
          fetched = data;
        }
      }, handleError);
    
  function runWithFS() {

    function assert(check, msg) {
      if (!check) throw msg + new Error().stack;
    }
Module['FS_createPath']('/', 'app', true, true);
Module['FS_createPath']('/', 'brick-app', true, true);
Module['FS_createPath']('/brick-app', 'lib', true, true);
Module['FS_createPath']('/', 'brick-script', true, true);
Module['FS_createPath']('/brick-script', 'brickscript', true, true);
Module['FS_createPath']('/brick-script', 'examples', true, true);
Module['FS_createPath']('/brick-script', 'test', true, true);
Module['FS_createPath']('/brick-script/test', 'parser', true, true);
Module['FS_createPath']('/brick-script/test/parser', 'complex', true, true);
Module['FS_createPath']('/brick-script/test/parser', 'simple', true, true);
Module['FS_createPath']('/brick-script/test', 'runtime', true, true);
Module['FS_createPath']('/', 'font', true, true);
Module['FS_createPath']('/font', 'cedders_segment7', true, true);
Module['FS_createPath']('/font', 'digital-graphics-labs_protestant', true, true);
Module['FS_createPath']('/', 'machine', true, true);

    function DataRequest(start, end, crunched, audio) {
      this.start = start;
      this.end = end;
      this.crunched = crunched;
      this.audio = audio;
    }
    DataRequest.prototype = {
      requests: {},
      open: function(mode, name) {
        this.name = name;
        this.requests[name] = this;
        Module['addRunDependency']('fp ' + this.name);
      },
      send: function() {},
      onload: function() {
        var byteArray = this.byteArray.subarray(this.start, this.end);

          this.finish(byteArray);

      },
      finish: function(byteArray) {
        var that = this;

        Module['FS_createDataFile'](this.name, null, byteArray, true, true, true); // canOwn this data in the filesystem, it is a slide into the heap that will never change
        Module['removeRunDependency']('fp ' + that.name);

        this.requests[this.name] = null;
      },
    };

        var files = metadata.files;
        for (i = 0; i < files.length; ++i) {
          new DataRequest(files[i].start, files[i].end, files[i].crunched, files[i].audio).open('GET', files[i].filename);
        }

  
    function processPackageData(arrayBuffer) {
      Module.finishedDataFileDownloads++;
      assert(arrayBuffer, 'Loading data file failed.');
      assert(arrayBuffer instanceof ArrayBuffer, 'bad input to processPackageData');
      var byteArray = new Uint8Array(arrayBuffer);
      var curr;
      
        // copy the entire loaded file into a spot in the heap. Files will refer to slices in that. They cannot be freed though
        // (we may be allocating before malloc is ready, during startup).
        if (Module['SPLIT_MEMORY']) Module.printErr('warning: you should run the file packager with --no-heap-copy when SPLIT_MEMORY is used, otherwise copying into the heap may fail due to the splitting');
        var ptr = Module['getMemory'](byteArray.length);
        Module['HEAPU8'].set(byteArray, ptr);
        DataRequest.prototype.byteArray = Module['HEAPU8'].subarray(ptr, ptr+byteArray.length);
  
          var files = metadata.files;
          for (i = 0; i < files.length; ++i) {
            DataRequest.prototype.requests[files[i].filename].onload();
          }
              Module['removeRunDependency']('datafile_game.data');

    };
    Module['addRunDependency']('datafile_game.data');
  
    if (!Module.preloadResults) Module.preloadResults = {};
  
      Module.preloadResults[PACKAGE_NAME] = {fromCache: false};
      if (fetched) {
        processPackageData(fetched);
        fetched = null;
      } else {
        fetchedCallback = processPackageData;
      }
    
  }
  if (Module['calledRun']) {
    runWithFS();
  } else {
    if (!Module['preRun']) Module['preRun'] = [];
    Module["preRun"].push(runWithFS); // FS is not initialized yet, wait for it
  }

 }
 loadPackage({"files": [{"audio": 0, "start": 0, "crunched": 0, "end": 615, "filename": "/conf.lua"}, {"audio": 0, "start": 615, "crunched": 0, "end": 2203, "filename": "/draw.lua"}, {"audio": 0, "start": 2203, "crunched": 0, "end": 2807, "filename": "/input.lua"}, {"audio": 0, "start": 2807, "crunched": 0, "end": 3337, "filename": "/main.lua"}, {"audio": 0, "start": 3337, "crunched": 0, "end": 4260, "filename": "/resources.lua"}, {"audio": 0, "start": 4260, "crunched": 0, "end": 4566, "filename": "/timer.lua"}, {"audio": 0, "start": 4566, "crunched": 0, "end": 5877, "filename": "/app/brickscript.lua"}, {"audio": 0, "start": 5877, "crunched": 0, "end": 7044, "filename": "/app/launcher.lua"}, {"audio": 0, "start": 7044, "crunched": 0, "end": 8973, "filename": "/app/nfs.lua"}, {"audio": 0, "start": 8973, "crunched": 0, "end": 9388, "filename": "/app/os.lua"}, {"audio": 0, "start": 9388, "crunched": 0, "end": 10426, "filename": "/app/snake.lua"}, {"audio": 0, "start": 10426, "crunched": 0, "end": 12303, "filename": "/app/tetris.lua"}, {"audio": 0, "start": 12303, "crunched": 0, "end": 12664, "filename": "/brick-app/1.brick"}, {"audio": 0, "start": 12664, "crunched": 0, "end": 13420, "filename": "/brick-app/2.brick"}, {"audio": 0, "start": 13420, "crunched": 0, "end": 15089, "filename": "/brick-app/1.lua"}, {"audio": 0, "start": 15089, "crunched": 0, "end": 18672, "filename": "/brick-app/2.lua"}, {"audio": 0, "start": 18672, "crunched": 0, "end": 19114, "filename": "/brick-app/lib/font.brick"}, {"audio": 0, "start": 19114, "crunched": 0, "end": 20703, "filename": "/brick-app/lib/font.lua"}, {"audio": 0, "start": 20703, "crunched": 0, "end": 20747, "filename": "/brick-script/.git"}, {"audio": 0, "start": 20747, "crunched": 0, "end": 21071, "filename": "/brick-script/.gitignore"}, {"audio": 0, "start": 21071, "crunched": 0, "end": 21330, "filename": "/brick-script/.travis.yml"}, {"audio": 0, "start": 21330, "crunched": 0, "end": 32687, "filename": "/brick-script/LICENSE"}, {"audio": 0, "start": 32687, "crunched": 0, "end": 33739, "filename": "/brick-script/README.md"}, {"audio": 0, "start": 33739, "crunched": 0, "end": 33998, "filename": "/brick-script/runtests.sh"}, {"audio": 0, "start": 33998, "crunched": 0, "end": 35313, "filename": "/brick-script/brickscript/compiler.lua"}, {"audio": 0, "start": 35313, "crunched": 0, "end": 37303, "filename": "/brick-script/brickscript/parser.lua"}, {"audio": 0, "start": 37303, "crunched": 0, "end": 43919, "filename": "/brick-script/brickscript/runtime.lua"}, {"audio": 0, "start": 43919, "crunched": 0, "end": 44355, "filename": "/brick-script/examples/usage.lua"}, {"audio": 0, "start": 44355, "crunched": 0, "end": 125620, "filename": "/brick-script/test/luaunit.lua"}, {"audio": 0, "start": 125620, "crunched": 0, "end": 125984, "filename": "/brick-script/test/parser-complex.lua"}, {"audio": 0, "start": 125984, "crunched": 0, "end": 126473, "filename": "/brick-script/test/parser-simple.lua"}, {"audio": 0, "start": 126473, "crunched": 0, "end": 127513, "filename": "/brick-script/test/runtime.lua"}, {"audio": 0, "start": 127513, "crunched": 0, "end": 129201, "filename": "/brick-script/test/parser/complex/cars.lua"}, {"audio": 0, "start": 129201, "crunched": 0, "end": 132424, "filename": "/brick-script/test/parser/complex/tetris.lua"}, {"audio": 0, "start": 132424, "crunched": 0, "end": 133894, "filename": "/brick-script/test/parser/simple/assign.lua"}, {"audio": 0, "start": 133894, "crunched": 0, "end": 137323, "filename": "/brick-script/test/parser/simple/call.lua"}, {"audio": 0, "start": 137323, "crunched": 0, "end": 137873, "filename": "/brick-script/test/parser/simple/comment.lua"}, {"audio": 0, "start": 137873, "crunched": 0, "end": 139300, "filename": "/brick-script/test/parser/simple/list.lua"}, {"audio": 0, "start": 139300, "crunched": 0, "end": 139855, "filename": "/brick-script/test/parser/simple/update.lua"}, {"audio": 0, "start": 139855, "crunched": 0, "end": 140104, "filename": "/brick-script/test/runtime/assign.lua"}, {"audio": 0, "start": 140104, "crunched": 0, "end": 140749, "filename": "/brick-script/test/runtime/bind.lua"}, {"audio": 0, "start": 140749, "crunched": 0, "end": 140842, "filename": "/brick-script/test/runtime/bitmap.lua"}, {"audio": 0, "start": 140842, "crunched": 0, "end": 142757, "filename": "/brick-script/test/runtime/call.lua"}, {"audio": 0, "start": 142757, "crunched": 0, "end": 143365, "filename": "/brick-script/test/runtime/comment.lua"}, {"audio": 0, "start": 143365, "crunched": 0, "end": 144150, "filename": "/brick-script/test/runtime/list.lua"}, {"audio": 0, "start": 144150, "crunched": 0, "end": 144623, "filename": "/brick-script/test/runtime/number.lua"}, {"audio": 0, "start": 144623, "crunched": 0, "end": 144716, "filename": "/brick-script/test/runtime/update.lua"}, {"audio": 0, "start": 144716, "crunched": 0, "end": 149204, "filename": "/font/cedders_segment7/OFL.txt"}, {"audio": 0, "start": 149204, "crunched": 0, "end": 159668, "filename": "/font/cedders_segment7/Segment7Standard.otf"}, {"audio": 0, "start": 159668, "crunched": 0, "end": 160788, "filename": "/font/digital-graphics-labs_protestant/!DigitalGraphicLabs.html"}, {"audio": 0, "start": 160788, "crunched": 0, "end": 162646, "filename": "/font/digital-graphics-labs_protestant/!license.txt"}, {"audio": 0, "start": 162646, "crunched": 0, "end": 196706, "filename": "/font/digital-graphics-labs_protestant/protest.ttf"}, {"audio": 0, "start": 196706, "crunched": 0, "end": 199153, "filename": "/machine/display.lua"}, {"audio": 0, "start": 199153, "crunched": 0, "end": 199526, "filename": "/machine/machine.lua"}], "remote_package_size": 199526, "package_uuid": "f1afe16c-9e85-4794-9a02-aabf684a88ad"});

})();
