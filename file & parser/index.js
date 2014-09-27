var exec = require('child_process').exec,child;

var fs=require('fs');
var url=require('url');
var server=require('http').createServer(function(request,response) {
	response.setHeader('Access-Control-Allow-Origin', '*');
    response.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
    response.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
    response.setHeader('Access-Control-Allow-Credentials', true);
	var test=url.parse(request.url,true);
	var query=test.query;
	response.writeHead(200, { 'Content-Type': 'application/json' });
	var stats=fs.statSync(query.path);
	if(stats.isFile()){
		child = exec('"./flex_bison/parser.exe" <"'+query.path+'"',
	  		function (error, stdout, stderr) {
			    if (error !== null) {
			      	console.log("exec error: " + error);
					response.end(JSON.stringify({"error": error}));
			      	return;
			  	}
				response.end(JSON.stringify({"parse":"ok","data": "["+stdout+"{}"+"]"}));
			}
		);
	}
	else if(stats.isDirectory()){
		fs.readdir(query.path,function (err,file) {
			if(err){
				response.end(JSON.stringify({"error":"error reading directory"}));
				return;
			}
			var files=[];
			for (var i = file.length - 1; i >= 0; i--) {
				files.push(file[i]);
			};
			response.end(JSON.stringify(files));
		});
	}
	else{
		response.end(JSON.stringify({"error": "no query"}));
      	return;
	}
});
server.listen(8002);