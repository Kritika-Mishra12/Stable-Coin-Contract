// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; 
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

library AddressUpgradeable {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

interface IFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
}

library Address {
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

    contract StormBitGameToken is Context, IERC20, Ownable {
    using Address for address payable;

    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) public allowedTransfer;
    mapping(address => bool) private _isBlacklisted;
    mapping(address => uint256) private _lastTrnx;
    bool public coolDownEnabled;
    uint256 public coolDownTime;

    IRouter public router;
    address public pair;

    uint8 private constant _decimals = 18;
    uint256 private constant MAX = ~uint256(0);

    uint256 private _tTotal;
    uint256 private _rTotal;
    uint256 private _initalCirtulation; 
    
    uint256 public maxBuyLimit;
    uint256 public maxSellLimit;
    uint256 public maxWalletLimit;
    address public toaddress;
    address public Coin;
    address public Token;

    uint256 public InitalTokenNumberPerCoin;
    uint256 public InitalTokenPoolSize;
    uint256 private ThresoldValue;
    uint256 private adjFlag;
    
    uint256 public InitalTokenPoolValue;
    uint256 public InitialCoinPoolValue;
    
    uint256 private AllowedPriceVariation;    
    uint256 public genesis_block;
    uint256 private deadline;

    address public deadWallet;
    string private constant _name = "STORM BIT GAME TOKEN";
    string private constant _symbol = "SBGU";

    uint256 public lpFees;

    struct TotFeesPaidStruct {
        uint256 liquidity;
    }

    TotFeesPaidStruct public totFeesPaid;

    struct valuesFromGetValues {
        uint256 rAmount;
        uint256 rTransferAmount;
        uint256 rLiquidity;
        uint256 tTransferAmount;
        uint256 tLiquidity;
    }

    event FeesChanged();
    event UpdatedRouter(address oldRouter, address newRouter);

    uint8 private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;
    mapping(address => uint256) private _lastTrx;
     /**
     * @dev Triggered when the contract has been initialized or reinitialized.
     */
    event Initialized(uint8 version);

    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
     * `onlyInitializing` functions can be used to initialize parent contracts. Equivalent to `reinitializer(1)`.
     */
    modifier initializer() {
        bool isTopLevelCall = _setInitializedVersion(1);
        if (isTopLevelCall) {
            _initializing = true;
        }
        _;
        if (isTopLevelCall) {
            _initializing = false;
            emit Initialized(1);
        }
    }

    /**
     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
     * used to initialize parent contracts.
     *
     * `initializer` is equivalent to `reinitializer(1)`, so a reinitializer may be used after the original
     * initialization step. This is essential to configure modules that are added through upgrades and that require
     * initialization.
     *
     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
     * a contract, executing them in the right order is up to the developer or operator.
     */
    modifier reinitializer(uint8 version) {
        bool isTopLevelCall = _setInitializedVersion(version);
        if (isTopLevelCall) {
            _initializing = true;
        }
        _;
        if (isTopLevelCall) {
            _initializing = false;
            emit Initialized(version);
        }
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} and {reinitializer} modifiers, directly or indirectly.
     */
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     */
    function _disableInitializers() internal virtual {
        _setInitializedVersion(type(uint8).max);
    }

    function _setInitializedVersion(uint8 version) private returns (bool) {
        // If the contract is initializing we ignore whether _initialized is set in order to support multiple
        // inheritance patterns, but we only do this in the context of a constructor, and for the lowest level
        // of initializers, because in other contexts the contract may have been reentered.
        if (_initializing) {
            require(
                version == 1 && !AddressUpgradeable.isContract(address(this)),
                "Initializable: contract is already initialized"
            );
            return false;
        } else {
            require(_initialized < version, "Initializable: contract is already initialized");
            _initialized = version;
            return true;
        }
    }
    
    function initialize(address routerAddress) public initializer {
        _setOwner(_msgSender());
        IRouter _router = IRouter(routerAddress);
        Coin = 0x55d398326f99059fF775485246999027B3197955;
        address _pair = IFactory(_router.factory()).createPair(address(this),Coin);
        router = _router;
        pair = _pair;
        Token=address(this);
        _tTotal = 100_000_000 * 10**_decimals;
        _rTotal = (MAX - (MAX % _tTotal));
        _rOwned[owner()] = _rTotal;
        _initalCirtulation =_tTotal * 10 / 100; 
    
        maxBuyLimit = 50000 * 10**_decimals;
        maxSellLimit = 50000 * 10**_decimals;
        maxWalletLimit = 50000 * 10**_decimals;
        toaddress = 0x22201002c3D3e38D48FA9DDb27965A93AA1f8539;
        InitalTokenNumberPerCoin = 1;
        InitalTokenPoolSize = 100_000;
        ThresoldValue = 50;
        adjFlag = 0;
        lpFees = 3;
        coolDownEnabled = true;
        coolDownTime = 0 seconds;
        
        InitalTokenPoolValue = InitalTokenPoolSize  * 10 ** 18;
        InitialCoinPoolValue =  InitalTokenPoolValue / InitalTokenNumberPerCoin;
        AllowedPriceVariation = InitalTokenNumberPerCoin *10**5* ThresoldValue /10000;    
        genesis_block = block.number;
        deadWallet = 0x000000000000000000000000000000000000dEaD;

        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[pair] = true;
        _isExcludedFromFee[deadWallet] = true;
        _isExcludedFromFee[0xD152f549545093347A162Dce210e7293f1452150] = true;
        _isExcludedFromFee[0x7ee058420e5937496F5a2096f04caA7721cF70cc] = true;  
    
        allowedTransfer[address(this)] = true;
        allowedTransfer[owner()] = true;
        allowedTransfer[pair] = true;
        allowedTransfer[0xD152f549545093347A162Dce210e7293f1452150] = true;
        allowedTransfer[0x7ee058420e5937496F5a2096f04caA7721cF70cc] = true;
    
        emit Transfer(address(0), owner(), _tTotal);
    }

    //std ERC20:
    function name() public pure returns (string memory) {
        return _name;
    }
    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    //override ERC20:
    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return tokenFromReflection(_rOwned[account]);
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender,address recipient,uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);
        return true;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferRfi) public view returns (uint256) {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferRfi) {
            valuesFromGetValues memory s = _getValues(tAmount, true, false);
            return s.rAmount;
        } else {
            valuesFromGetValues memory s = _getValues(tAmount, true, false);
            return s.rTransferAmount;
        }
    }
 
    function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
        require(rAmount <= _rTotal, "Amount must be less than total reflections");
        uint256 currentRate = _getRate();
        return rAmount / currentRate;
    }

    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function _takeLiquidity(uint256 rLiquidity, uint256 tLiquidity) private {
        totFeesPaid.liquidity += tLiquidity;
        _rOwned[address(this)] += rLiquidity;
    }

    function _getValues(uint256 tAmount,bool takeFee,bool isSell) private view returns (valuesFromGetValues memory to_return) {
        to_return = _getTValues(tAmount, takeFee, isSell);
        (
            to_return.rAmount,
            to_return.rTransferAmount,
            to_return.rLiquidity
        ) = _getRValues1(to_return, tAmount, takeFee, _getRate());
        return to_return;
    }

    function _getTValues(uint256 tAmount,bool takeFee,bool isSell) private view returns (valuesFromGetValues memory s) {
        if (!takeFee) {
            s.tTransferAmount = tAmount;
            return s;
        }
        uint256 _lpfee=0;
        if(isSell) _lpfee = lpFees;
        s.tLiquidity = (tAmount * _lpfee) / 100;
        s.tTransferAmount = tAmount - s.tLiquidity;
        return s;
    }

    function _getRValues1(valuesFromGetValues memory s,uint256 tAmount,bool takeFee,uint256 currentRate) private pure
        returns (uint256 rAmount,uint256 rTransferAmount,uint256 rLiquidity)
    {
        rAmount = tAmount * currentRate;
        if (!takeFee) {
            return (rAmount, rAmount, 0);
        }
        rLiquidity = s.tLiquidity * currentRate;
        rTransferAmount = rAmount - rLiquidity ;
        return (rAmount, rTransferAmount, rLiquidity);
    }

    function _getRate() public view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = (_rTotal,_tTotal);
        return rSupply / tSupply;
    }


    function _approve(address owner,address spender,uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from,address to,uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        require(
            amount <= balanceOf(from),
            "You are trying to transfer more than your balance"
        );
        require(!_isBlacklisted[from] && !_isBlacklisted[to], "You are a bot");

        if (from == pair && !_isExcludedFromFee[to] ) {
            require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
            require(
                balanceOf(to) + amount <= maxWalletLimit,
                "You are exceeding maxWalletLimit"
            );
        }
        if (
            from != pair && !_isExcludedFromFee[to] && !_isExcludedFromFee[from] 
        ) {
            require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
            if (to != pair) {
                require(
                    balanceOf(to) + amount <= maxWalletLimit,
                    "You are exceeding maxWalletLimit"
                );
            }
            if (coolDownEnabled) {
                uint256 timePassed = block.timestamp - _lastTrnx[from];
                require(timePassed >= coolDownTime, "Cooldown enabled");
                _lastTrnx[from] = block.timestamp;
            }
        }
        bool takeFee = true;
        bool isSell = false;
        if ( _isExcludedFromFee[from] || (_isExcludedFromFee[to] && to != pair)) takeFee = false;
        if (to == pair){
            isSell = true;
        } 
        _tokenTransfer(from, to, amount, takeFee, isSell);
    }

    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(address sender,address recipient,uint256 tAmount,bool takeFee,bool isSell) private {
        valuesFromGetValues memory s = _getValues(tAmount, takeFee, isSell);
        
        _rOwned[sender] = _rOwned[sender] - s.rAmount;
        _rOwned[recipient] = _rOwned[recipient] + s.rTransferAmount;

        if (s.rLiquidity > 0 || s.tLiquidity > 0) {
            _takeLiquidity(s.rLiquidity, s.tLiquidity);
            emit Transfer(sender,address(this),s.tLiquidity);
        }
        emit Transfer(sender, recipient, s.tTransferAmount);
        
        if(balanceOf(address(this)) != 0 && adjFlag != 0){
            swap();
        }
    }

    function getExchangeRateRate() public view returns(uint256) {
        return IERC20(Token).balanceOf(pair)/IERC20(Coin).balanceOf(pair);
    }

    function getTokenBalance() public view returns(uint256){
        require(Token != address(0), "ERC20: Balance not possible from the zero address");
        uint256 rate = IERC20(Token).balanceOf(pair);
        return rate;
    }

    function getCoinBalance() public view returns(uint256){
        require(Coin != address(0), "ERC20: Balance not possible from the zero address");
        uint256 rate = IERC20(Coin).balanceOf(pair);
        return rate;
    }

    function detectPoolVarition() public view returns (bool,uint256,uint256,uint256){
        if(Coin == address(0) || Token == address(0)) return (false,0,0,0);
        uint256 CurrentTokenBalance = IERC20(Token).balanceOf(pair);
        uint256 CurrentCoinBalance = IERC20(Coin).balanceOf(pair);
        if(CurrentTokenBalance==0 || CurrentCoinBalance==0) return (false,0,0,0);
        uint256 CurrentTokenNumberPerCoin = CurrentTokenBalance*10**5/CurrentCoinBalance;
        uint256 CurrentPriceVariation = abs(CurrentTokenNumberPerCoin , InitalTokenNumberPerCoin*10**5);
        if(CurrentPriceVariation > AllowedPriceVariation){
            if(CurrentTokenNumberPerCoin > InitalTokenNumberPerCoin*10**5){
                uint256 Token_Out =(CurrentPriceVariation * CurrentCoinBalance/2)/10**5;
                uint256 Coin_in = ((1*10**18)/(InitalTokenNumberPerCoin*10**5) - (1*10**18)/CurrentTokenNumberPerCoin)*CurrentTokenBalance/2/(1*10**13);
                return (true,Token_Out,Coin_in,1);
            }
            if(CurrentTokenNumberPerCoin < InitalTokenNumberPerCoin*10**5){
                uint256 Token_in =(CurrentPriceVariation * CurrentCoinBalance/2)/10**5;
                uint256 Coin_Out = ((1*10**18)/CurrentTokenNumberPerCoin - (1*10**18)/(InitalTokenNumberPerCoin*10**5))*CurrentTokenBalance/2/(1*10**13);
                return (true,Token_in,Coin_Out,2);
            }
            else{
                return (false,0,0,3);
            }
        }
        else{
                return (false,0,0,4);
        }
    }
    
    function swap() public {
        uint256 _Token;
        uint256 coin;
        uint256 dir;
        bool Status;
        (Status,_Token,coin,dir)=detectPoolVarition();
        if(Status){
            if(dir==1){
                swapEthForToken(coin,_Token);
            }
            if(dir==2){
               swapTokensForBNB(coin,_Token);
            }
        }
    } 

    function swapTokensForBNB(uint256 coinAmount,uint256 tokenAmount) private {
        // generate the pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = Token;
        path[1] = Coin;

        _approve(address(this), address(router), tokenAmount);
        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            coinAmount*(100-50)/100,
            path,
            toaddress,
            block.timestamp + 3600
        );
    }

    function swapEthForToken(uint256 coinAmount,uint256 tokenAmount) private  {
        // generate the pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = Coin;
        path[1] = Token;
        
        IERC20(Coin).approve(address(router), coinAmount);
        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            coinAmount,
            tokenAmount*(100-50)/100,
            path,
            toaddress,
            block.timestamp + 3600
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(router), tokenAmount);
        // add the liquidity
        (bool success, ) = address(router).call{value: bnbAmount}(
            abi.encodeWithSignature("addLiquidityETH(address,uint256,uint256,uint256,address,uint256)", address(this), tokenAmount, 0, 0, address(this), block.timestamp));
        require(success, "Add liquidity failed");
    }

    function abs(uint256  x, uint256 y) private pure returns (uint256) {
        if(x>=y)
        {
           return (x-y);
        }
        else
        {
           return(y-x);
        }
    }

    function setLiquidityFeePercent(uint256 _newlpFee) external onlyOwner {
        lpFees = _newlpFee;
    }

    function setThresoldValue(uint256 _newThresoldValue) external onlyOwner {
        ThresoldValue = _newThresoldValue;
        AllowedPriceVariation = InitalTokenNumberPerCoin *10**5* ThresoldValue /10000; 
    }

    function setadjFlag(uint256 _newAdjFlag) external onlyOwner {
        adjFlag = _newAdjFlag;
    }

    function updateIsBlacklisted(address account, bool state) external onlyOwner {
        _isBlacklisted[account] = state;
    }

    function bulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            _isBlacklisted[accounts[i]] = state;
        }
    }
    function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell) external onlyOwner {
        maxBuyLimit = maxBuy * 10**decimals();
        maxSellLimit = maxSell * 10**decimals();
    }

    function updateMaxWalletlimit(uint256 amount) external onlyOwner {
        maxWalletLimit = amount * 10**decimals();
    }

    function updateRouterAndPair(address newRouter, address newPair) external onlyOwner {
        require(newRouter != address(0),"New router address can not be zero");
        router = IRouter(newRouter);
        require(newPair != address(0),"New pair address can not be zero");
        pair = newPair;
        _isExcludedFromFee[pair] = true;
        allowedTransfer[pair] = true;
    }

    function setToAddress(address newAdress) external onlyOwner {
        toaddress = newAdress;
    }
    
    function updateCooldown(bool state, uint256 time) external onlyOwner {
        coolDownTime = time * 1 seconds;
        coolDownEnabled = state;
    }

    function updateAllowedTransfer(address account, bool state) external onlyOwner {
        allowedTransfer[account] = state;
    }

    function rescueBNB(uint256 weiAmount) external onlyOwner {
        require(address(this).balance >= weiAmount, "insufficient BNB balance");
        payable(msg.sender).transfer(weiAmount);
    }

    function rescueAnyBEP20Tokens(address _tokenAddr,address _to,uint256 _amount) public onlyOwner {
        require(_tokenAddr != address(0), "tokenAddress cannot be the zero address");
        require(_to != address(0), "receiver cannot be the zero address");
        require(_amount > 0, "amount should be greater than zero");
        IERC20 token = IERC20(_tokenAddr);
        bool success = token.transfer(_to, _amount);
        require(success, "Token transfer failed");
    }

    receive() external payable {}
}
