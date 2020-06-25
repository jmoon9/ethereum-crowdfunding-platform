import Web3 from 'web3';
import { NETWORK_URL } from '../constants';

let web3;

if(typeof window !== 'undefined' && typeof window.web3 !== 'undefined'){      
    // code runs inside browser and MetaMask has injected web3
    web3 = new Web3(window.web3.currentProvider);
}
else{ 
    // code runs on node.js server at runtime **OR** user's browser is not running metamask
    const provider = new Web3.providers.HttpProvider(
        NETWORK_URL
    );

    web3 = new Web3(provider);
}

export default web3;