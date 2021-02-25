pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import { PhotoNFTPutOnSale } from "./PhotoNFTPutOnSale.sol";
import { ERC721Full } from "./openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
import { SafeMath } from "./openzeppelin-solidity/contracts/math/SafeMath.sol";


/**
 * @notice - This is the NFT contract for a photo
 */
contract PhotoNFT is ERC721Full, PhotoNFTPutOnSale {
    using SafeMath for uint256;

    uint256 public currentPhotoId;

    struct PhotoData {  /// [Key]: photoNFT contract address
        string photoNFTName;
        string photoNFTSymbol;
        address ownerAddress;
        uint photoPrice;
        string ipfsHashOfPhoto;
        uint256 reputation;
    }
    mapping (address => PhotoData) photoDatas;  /// [Key]: photoNFT contract address
    
    constructor(
        string memory _nftName, 
        string memory _nftSymbol,
        string memory _tokenURI,    /// [Note]: TokenURI is URL include ipfs hash
        uint photoPrice
    ) 
        public 
        ERC721Full(_nftName, _nftSymbol) 
        PhotoNFTPutOnSale(this) 
    {
        _mint(msg.sender, currentPhotoId);
        _setTokenURI(currentPhotoId, _tokenURI);

        /// Put on sale (by a seller == owner)
        uint photoId = 0;
        openTrade(photoId, photoPrice);
    }

    /** 
     * @notice - Save a photoNFT data
     */
    function savePhotoNFTData(string memory _photoNFTName, string memory _photoNFTSymbol, address _ownerAddress, uint _photoPrice, string memory _ipfsHashOfPhoto) public returns (bool) {
        PhotoData storage photoData = photoDatas[address(this)];
        photoData.photoNFTName = _photoNFTName;
        photoData.photoNFTSymbol = _photoNFTSymbol;
        photoData.ownerAddress = _ownerAddress;
        photoData.photoPrice = _photoPrice;
        photoData.ipfsHashOfPhoto = _ipfsHashOfPhoto;
        photoData.reputation = 0;
    }

    /** 
     * @dev mint a photoNFT
     * @dev tokenURI - URL include ipfs hash
     */
    function mint(address to, string memory tokenURI) public returns (bool) {
        /// Mint a new PhotoNFT
        uint newPhotoId = getNextPhotoId();
        currentPhotoId++;
        _mint(to, newPhotoId);
        _setTokenURI(newPhotoId, tokenURI);
    }


    ///--------------------------------------
    /// Getter methods
    ///--------------------------------------
    function getPhotoData(address photoNFTContractAddress) public view returns (PhotoData memory _photoData) {
        PhotoData memory photoData = photoDatas[photoNFTContractAddress];
        return photoData;
    }

    function getPhotoTrade(uint256 _trade) public view returns (Trade memory trade_) {
        return getTrade(_trade);
    }
    


    ///--------------------------------------
    /// Private methods
    ///--------------------------------------
    function getNextPhotoId() private returns (uint nextPhotoId) {
        return currentPhotoId.add(1);
    }
    

}
