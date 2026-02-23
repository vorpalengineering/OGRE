// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {IActionHopper} from "./IActionHopper.sol";

/**
 * @notice Open Governance Referendum Engine Proposal Interface
 */
interface IOGREProposal {

    //========== Definitions ==========

    /**
     * Proposal Status Flow:
     *     PROPOSED - CANCELLED
     *        |    \
     *      PASSED  FAILED
     *        |
     *     EXECUTED
     */
    enum ProposalStatus {
        PROPOSED,
        CANCELLED,
        FAILED,
        PASSED,
        EXECUTED
    }

    /**
     * NO:
     * YES:
     * ABSTAIN:
     */
    enum VoteDirection {
        NO,
        YES,
        ABSTAIN
    }

    struct ConstructorParams {
        bool revotable;
        address daoAddress;
        address owner;
        string proposalURI;
    }

    struct Vote {
        VoteDirection direction;
        bool voted;
    }

    //========== Functions ==========

    function proposalURI() external view returns (string memory);
    function status() external view returns (ProposalStatus);
    function startTime() external view returns (uint256);
    function endTime() external view returns (uint256);
    function voteTotals(uint256 vote) external view returns (uint256);
    function getActionCount() external view returns (uint256);
    function getAction(uint256 index) external view returns (IActionHopper.Action memory);

    function updateStatus(ProposalStatus newStatus) external;
    function setActionReady(uint256 index, uint256 readyTime) external;
}
