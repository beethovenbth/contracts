// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './BEP20.sol';

contract BTH is BEP20 {
  constructor() BEP20( 'Beethoven', 'BTH', 18, 0 ) {}
}
