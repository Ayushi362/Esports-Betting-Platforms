# Esports Betting Platform

## Project Description

The Esports Betting Platform is a decentralized smart contract built on the Stacks blockchain using Clarity language. This platform enables users to place bets on esports tournaments and matches in a trustless, transparent manner. The system automatically handles bet placement, pool management, and payout distribution without requiring intermediaries.

The platform supports betting on match outcomes between two teams, with automatic calculation of winnings based on the total betting pools and winning percentages. All transactions are secured by the blockchain, ensuring fair play and transparent operations.

## Project Vision

Our vision is to revolutionize the esports betting industry by creating a fully decentralized platform that:

- **Eliminates Trust Issues**: Smart contracts ensure automatic and fair payout distribution
- **Increases Transparency**: All betting data and transactions are publicly verifiable on the blockchain
- **Reduces Costs**: No traditional bookmaker margins, only minimal platform fees
- **Global Accessibility**: Anyone with a crypto wallet can participate regardless of geographical location
- **Community-Driven**: Decentralized governance for platform decisions and improvements

We aim to become the leading decentralized betting platform for the growing esports industry, providing a secure and fair environment for esports enthusiasts worldwide.

## Future Scope

### Phase 1 - Core Enhancement (Q1-Q2 2025)
- **Multi-Tournament Support**: Expand beyond single matches to support tournament brackets
- **Live Betting**: Implement in-game betting with real-time odds updates
- **Mobile Integration**: Develop mobile-friendly interfaces and wallet integrations
- **Oracle Integration**: Connect with esports data providers for automated match results

### Phase 2 - Advanced Features (Q3-Q4 2025)
- **NFT Integration**: Allow betting with esports-themed NFTs as collateral
- **Governance Token**: Launch platform governance token for community voting
- **Prediction Markets**: Expand to player performance and tournament outcome predictions
- **Cross-Chain Support**: Enable betting across multiple blockchain networks

### Phase 3 - Ecosystem Expansion (2026)
- **Esports Team Partnerships**: Direct integration with professional esports organizations
- **Streaming Platform Integration**: Embed betting features in popular streaming platforms
- **Social Features**: Add community features, leaderboards, and social betting
- **AI-Powered Analytics**: Provide betting insights and match predictions

### Long-term Vision
- **Regulatory Compliance**: Work with regulators to ensure legal operation globally
- **Traditional Sports Expansion**: Extend platform to traditional sports betting
- **DeFi Integration**: Incorporate yield farming and liquidity mining features
- **Metaverse Integration**: Enable betting in virtual esports environments

## Contract Address Details



**Network**: Stacks Blockchain  
**Contract Address**: ST2MWE03FS3CN71MDBWYMAHZMMDZMYP5QDYFDCR5B.EsportsBettingPlatform
<img width="1919" height="787" alt="Screenshot 2025-08-26 121658" src="https://github.com/user-attachments/assets/8225df8c-fe07-48d2-a6ca-6fafa8c68c4a" />

### Contract Functions

#### Main Functions:
1. **place-bet(match-id, team-choice)** - Place a bet on a specific match
2. **claim-winnings(match-id)** - Claim winnings after match completion

#### Read-Only Functions:
- **get-match-info(match-id)** - Retrieve match details
- **get-user-bet(user, match-id)** - Get user's bet information
- **get-contract-balance()** - Check contract's STX balance

#### Owner Functions:
- **create-match(team-a, team-b, tournament)** - Create new betting matches
- **complete-match(match-id, winning-team-id)** - Mark match as completed with winner

### Usage Instructions

1. **Placing a Bet**: Call `place-bet` with the match ID and team choice (1 or 2)
2. **Viewing Matches**: Use `get-match-info` to see available matches and current pools
3. **Claiming Rewards**: After match completion, call `claim-winnings` to receive your payout
4. **Checking Bets**: Use `get-user-bet` to view your betting history and status

### Security Features

- **Automated Payouts**: Smart contract handles all payout calculations
- **Transparent Pools**: All betting pools are publicly visible
- **No Double Betting**: Users can only bet once per match
- **Secure Fund Handling**: STX tokens are held securely in the contract
- **Platform Fee**: 5% platform fee to maintain and improve the service


