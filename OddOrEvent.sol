// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Strings.sol";

contract OddOrEven {
    string public choisePlayer1 = "";
    address public player1;
    uint8 private numberPlayer1;
    string public status = "";

    function compare(string memory str1, string memory str2) private pure returns (bool){
        bytes memory arrA = bytes(str1);
        bytes memory arrB = bytes(str2);

        return  arrA.length == arrB.length && keccak256(arrA) == keccak256(arrB);
    }

    function choose(string memory newChoise) public {
        require(compare(newChoise, "EVEN") || compare(newChoise, "ODD"), "Choose EVEN or ODD");

        string memory message = string.concat("Player 1 already choose ", choisePlayer1);
        require(compare(choisePlayer1, ""), message);

        choisePlayer1 = newChoise;
        player1 = msg.sender;
        status = string.concat("Player 1 is ", Strings.toHexString(player1), " and choose ", choisePlayer1);
    }

    function play(uint8 number) public {
        require(!compare(choisePlayer1, ""), "First, choose your option (Even or Odd)");
        require(number > 0, "The number muist be greater than 0");

        if (msg.sender == player1){
            numberPlayer1 = number;
            status = "Player 1 already played. Waiting player 2";
        }else{
            require(numberPlayer1 != 0, "Player 1 need play first");
            bool isEven = (numberPlayer1 + number) % 2 == 0;
            string memory message = string.concat("Player choose ", 
                choisePlayer1, 
                ", and plays ", 
                Strings.toString(numberPlayer1), 
                ". Player 2 plays ", 
                Strings.toString(number));

            if (isEven && compare(choisePlayer1, "EVEN")){
                status = string.concat(message, ". Player 1 won.");
            }else if (!isEven && compare(choisePlayer1, "ODD")){
                status = string.concat(message, ". Player 1 won.");
            }else{
                status = string.concat(message, ". Player 2 won.");
                choisePlayer1 = "";
                numberPlayer1 = 0;
                player1 = address(0);
            }
        }
    }
}