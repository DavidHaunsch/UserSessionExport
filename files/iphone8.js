var casper = require('casper').create();

casper.start();
casper.viewport(360, 740);
casper.userAgent('Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.34 (KHTML, like Gecko) Version/11.0 Mobile/15A5341f Safari/604.1)');

casper.thenOpen('http://PUBLIC_IP/', function() {
  this.echo(this.getTitle());
});

casper.thenOpen('http://PUBLIC_IP/detail.html?id=819e1fbf-8b7e-4f6d-811f-693534916a8b', function() {
  this.echo(this.getTitle());
});

casper.run();