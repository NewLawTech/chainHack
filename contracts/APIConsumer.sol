pragma solidity >=0.6.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

/**
 * THIS IS AN EXAMPLE CONTRACT WHICH USES HARDCODED VALUES FOR CLARITY.
 * PLEASE DO NOT USE THIS CODE IN PRODUCTION.
 */
contract APIConsumer is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    uint256 public volume;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    /**
     * Network: Kovan
     * Oracle: 0xfF07C97631Ff3bAb5e5e5660Cdf47AdEd8D4d4Fd (LuxFi Luxury Asset Data Oracle)
     * Job ID: 3059562ad6bb495893eff9b4b0940f28
     * Fee: 0.1 LINK
     */
    constructor() public {
        setPublicChainlinkToken();
        oracle = 0xfF07C97631Ff3bAb5e5e5660Cdf47AdEd8D4d4Fd;
        jobId = "3059562ad6bb495893eff9b4b0940f28";
        fee = 0.1 * 10 ** 18; // 0.1 LINK
    
    }

    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000000000000000000 (to remove decimal places from data).
     */
    function requestLuxFiData() public returns (bytes32 requestId)
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

        // Set the URL to perform the GET request on
        request.add("get", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD");

        // Set the path to find the desired data in the API response, where the response format is:
        {
            "jobRunID": "1",
            "data": {
                "numberOfElements": 1,
                "totalElements": 1,
                "content": [
                {
                    "id": 104659,
                    "price": 1299.59,
                    "o_price": 0,
                    "brand": "Dior",
                    "brand_id": 6,
                    "series": "Lady Dior",
                    "series_id": 1786,
                    "color": "Black",
                    "color_id": 1,
                    "category": "Tote Bag",
                    "type_id": 6,
                    "material": "Patent Leather",
                    "material_id": 53,
                    "grade": "9.5",
                    "grade_id": 3,
                    "vendor": "PaiPai",
                    "vendor_id": 227,
                    "web_name": "paipai",
                    "size": null,
                    "spu": "B6S1786M53",
                    "sku": "0/paipai10025710362992",
                    "img_count": "1",
                    "sold_count": "0",
                    "title": "【二手95新】DIOR 迪奥黑银漆皮七格戴妃包奢侈品女士包",
                    "detail_url": "https://paipai.m.jd.com/m/goods_detail_c.html?usedNo=10025710362992",
                    "area_id": 41,
                    "on_chain": 0,
                    "created_at": "2021-05-21 07:15:34",
                    "size2": {
                    "cm": null,
                    "inch": null
                    },
                    "soldDate": "2021-01-05"
                }
                ],
                "size": 200,
                "totalPages": 1,
                "number": 0,
                "result": 1299.59
            },
            "result": 1299.59,
            "statusCode": 200
            }
        request.add("path", "data.content.price");

        // Multiply the result by 1000000000000000000 to remove decimals
        int timesAmount = 10**18;
        request.addInt("times", timesAmount);

        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    /**
     * Receive the response in the form of uint256
     */
    function fulfill(bytes32 _requestId, uint256 _volume) public recordChainlinkFulfillment(_requestId)
    {
        volume = _volume;
    }

    function stringToBytes32(string memory source) public pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }

    // function withdrawLink() external {} - Implement a withdraw function to avoid locking your LINK in the contract
}

