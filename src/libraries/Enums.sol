// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

library OGREMarketEnums {
    
    /**
     * ASK:
     * BID:
     */
    enum OrderType {
        ASK,
        BID
    }

    /**
     * ERC20:
     * ERC721:
     * ERC1155:
     */
    enum ContractType {
        ERC20,
        ERC721,
        ERC1155
    }
    
}

library OGREProposalEnums {
    
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

}