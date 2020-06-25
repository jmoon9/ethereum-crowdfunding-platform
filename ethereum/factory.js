import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

const instance = new web3.eth.Contract(
    CampaignFactory.abi,
    "0x41E6BAf507b091B56b5B89e100c2D106e648f3A4"
);

export default instance;