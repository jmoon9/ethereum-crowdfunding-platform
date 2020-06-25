import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

const instance = new web3.eth.Contract(
    CampaignFactory.abi,
    "0xD6511D9170817Cf15299D439b72667A208EE510D"
);

export default instance;