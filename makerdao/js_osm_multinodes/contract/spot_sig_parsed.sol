
// along with this program.  If not, see <https:

pragma solidity >=0.5.12;

import "./lib.sol";

interface VatLike {
    function file(bytes32, bytes32, uint) external;
}

interface PipLike {
    function peek() external returns (bytes32, bool);
}

contract Spotter is LibNote {
    
    mapping (address => uint) public wards;
    function rely(address guy) external note auth { wards[guy] = 1;  }
    function deny(address guy) external note auth { wards[guy] = 0; }
    modifier auth {
        require(wards[msg.sender] == 1, "Spotter/not-authorized");
        _;
    }

    
    struct Ilk {
        PipLike pip;  
        uint256 mat;  
    }

    mapping (bytes32 => Ilk) public ilks;

    VatLike public vat;  
    uint256 public par;  

    uint256 public live;

    
    event Poke(
      bytes32 ilk,
      bytes32 val,  
      uint256 spot  
    );

    bytes32 public price;


    
    uint constant ONE = 10 ** 27;

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }
    function rdiv(uint x, uint y) internal pure returns (uint z) {
        z = mul(x, ONE) / y;
    }

    
    function file(bytes32 ilk, bytes32 what, address pip_) external note auth {
        require(live == 1, "Spotter/not-live");
        if (what == "pip") ilks[ilk].pip = PipLike(pip_);
        else revert("Spotter/file-unrecognized-param");
    }
    function file(bytes32 what, uint data) external note auth {
        require(live == 1, "Spotter/not-live");
        if (what == "par") par = data;
        else revert("Spotter/file-unrecognized-param");
    }
    function file(bytes32 ilk, bytes32 what, uint data) external note auth {
        require(live == 1, "Spotter/not-live");
        if (what == "mat") ilks[ilk].mat = data;
        else revert("Spotter/file-unrecognized-param");
    }

    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // GENERATED BY SIGNALSLOT PARSER

    // Original Code:
    // handler updatePrice {...}

    // Generated variables that represent the slot
    uint private updatePrice_status;
    bytes32 private updatePrice_key;

    // Get the signal key
	function get_updatePrice_key() public view returns (bytes32 key) {
       return updatePrice_key;
    }

    // updatePrice construction
    // Should be called once in the contract construction
    function updatePrice() private {
        updatePrice_key = keccak256("updatePrice_func(bytes32)");
        assembly {
            sstore(updatePrice_status_slot, createslot(1, 10, 30000, sload(updatePrice_key_slot)))
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////

    // updatePrice code to be executed
    // The slot is converted to a function that will be called in slot transactions.
    function updatePrice_func(bytes32 data)  external  {
        price = data;
    }

    function poke_to_bind(address osm_addr) external {
        //////////////////////////////////////////////////////////////////////////////////////////////////
        // GENERATED BY SIGNALSLOT PARSER

        // Original Code:
        // updatePrice.bind(osm_addr.PriceFeedUpdate)

        // Convert to address
		address osm_addr_bindslot_address = address(osm_addr);
        // Get signal key from emitter contract
		bytes32 osm_addr_bindslot_PriceFeedUpdate_key = keccak256("PriceFeedUpdate()");
        // Get slot key from receiver contract
        bytes32 this_osm_addr_bindslot_updatePrice_key = get_updatePrice_key();
        // Use assembly to bind slot to signal
		assembly {
			mstore(0x40, bindslot(osm_addr_bindslot_address, osm_addr_bindslot_PriceFeedUpdate_key, this_osm_addr_bindslot_updatePrice_key))
	    }
        //////////////////////////////////////////////////////////////////////////////////////////////////

    }

    function poke_to_detach(address osm_addr) external {
        //////////////////////////////////////////////////////////////////////////////////////////////////
        // GENERATED BY SIGNALSLOT PARSER

        // Original Code:
        // this.updatePrice.detach(osm_addr.PriceFeedUpdate)

        // Get the signal key
		bytes32 osm_addr_detach_PriceFeedUpdate_key = keccak256("PriceFeedUpdate()");
        // Get the address
		address osm_addr_detach_address = address(osm_addr);
        //Get the slot key
        bytes32 this_osm_addr_bindslot_updatePrice_key = get_updatePrice_key();
        // Use assembly to detach the slot
		assembly{
			mstore(0x40, detachslot(osm_addr_detach_address, osm_addr_detach_PriceFeedUpdate_key, this_osm_addr_bindslot_updatePrice_key))
		}
        //////////////////////////////////////////////////////////////////////////////////////////////////

    }
    
    function getPrice() public returns(bytes32) {
        return price;
    }

    function cage() external note auth {
        live = 0;
    }
    
    constructor() public {
   updatePrice();
        wards[msg.sender] = 1;
        par = ONE;
        live = 1;
    }
    
}
