// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

/**
 * @notice OGRE DAO Interface
 */
interface IOGREDAO {

    //========== Definitions ==========

    /**
     * UNREGISTERED: member has not registered, or elected to unregister after previously being registered
     * REGISTERED: member is registered
     * BANNED: member has been banned and cannot be registered again
     */
    enum MemberStatus {
        UNREGISTERED,
        REGISTERED,
        BANNED
    }

    /**
     * OPEN: any nft holder can self-register as a member
     * INVITE: only dao members can register a member
     * PRIVATE: only dao can register a member
     */
    enum AccessType {
        OPEN,
        INVITE,
        PRIVATE
    }

    struct ConstructorParams {
        address parentDAO;
        address nftAddress;
        address proposalFactoryAddress;
        uint256 proposalCost;
        address proposalCostToken;
        uint256 quorumThreshold;
        uint256 supportThreshold;
        uint256 minVoteDuration;
        uint256 delay;
        uint256[] allowList;
        uint256[] initialMembers;
    }

    //========== Functions ==========

    function parentDAO() external view returns (address);
    function proposalFactoryAddress() external view returns (address);
    function nftAddress() external view returns (address);

    function quorumThreshold() external view returns (uint256);
    function supportThreshold() external view returns (uint256);
    function minVoteDuration() external view returns (uint256);

    function memberCount() external view returns (uint256);
    function getMemberStatus(uint256 tokenId) external view returns (MemberStatus);

    function proposalCount() external view returns (uint256);
    function proposals(uint256) external view returns (address);
    function isProposal(address proposal) external view returns (bool);
    
    function setQuorumThreshold(uint256 newQuorumThreshold) external;
    function setSupportThreshold(uint256 newSupportThreshold) external;
    function setMinVoteDuration(uint256 newMinVoteDuration) external;
}