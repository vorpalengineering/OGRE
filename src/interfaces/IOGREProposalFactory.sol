// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

/**
 * @notice Open Governance Referendum Engine Proposal Factory Interface
 */
interface IOGREProposalFactory {
    function produceOGREProposal(string memory title, address daoAddress, address owner) external returns (address);
}