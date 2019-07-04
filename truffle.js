module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8546,
      network_id: "*" // Match any network id
    },

    // test: {
    //   host: "127.0.0.1",
    //   port: 8546,
    //   network_id: "*" // Match any network id
    // },

  },

  compilers: {
    solc: {
      version: "^0.5.0", // A version or constraint - Ex. "^0.5.0"
                         // Can also be set to "native" to use a native solc
    }
  }
};
