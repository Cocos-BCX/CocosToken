module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8546,
      network_id: "*" // Match any network id
    },

    test: {
      host: "127.0.0.1",
      port: 8546,
      network_id: "*" // Match any network id
    },

    mainnet: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*", // Match any network id
      //gas: 4700036
    },

    kovan:  {
      network_id: "4", // Match any network id
      host: "https://api.infura.io/v1/jsonrpc/kovan",
      // port:  8545,
      // gas: 4700036
    }


  },

  compilers: {
    solc: {
      version: "^0.5.0", // A version or constraint - Ex. "^0.5.0"
                         // Can also be set to "native" to use a native solc
    }
  }
};
