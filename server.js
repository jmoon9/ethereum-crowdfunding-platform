const { createServer } = require('http');
const next = require('next');
const app = next({
    dev: process.env.NODE_ENV !== 'production'
});

const routes = require('./routes');
const handler = routes.getRequestHandler(app);
const port = process.env.PORT || 3000;

app.prepare().then(() => {
    createServer(handler).listen(port, (err) => {
        if(err) throw err;
        console.log('Listening on ', port);
    });
});


//0x62dB26E61712Fc4b6da332D7E77dff9EF1c96A84
//0x62dB26E61712Fc4b6da332D7E77dff9EF1c96A84