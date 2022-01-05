/* eslint-disable node/no-missing-import */
import { config } from "../config";
import contracts from "../../contracts.json";
import { ProviderState, useWeb3Provider } from "vue-ethers";
import { AppState } from "./AppState";
import { Moralis } from "moralis/dist/moralis.min.js";

Moralis.initialize(config.moralisKey);
Moralis.serverURL = config.moralisServerUrl;

const setUser = () => {
  AppState.user = Moralis.User.current();
};

const initUser = async (user: Moralis.User) => {
  setUser(user);
  ProviderState.account = user.attributes.accounts[0];
};

const logout = async () => {
  await Moralis.User?.logOut();
  ProviderState.account = "";
  AppState.user = Moralis.User.current();
};

export const initProvider = () => {
  const init = async () => {
    if (window.ethereum) {
      const currentUser = Moralis.User.current();
      if (currentUser) {
        initUser(currentUser);
      }
    }
  };

  useWeb3Provider(init, null, AppState, config, contracts.contracts);
};

const setMessage = (message: string) => {
  console.log(message);
};

export const useMoralis = () => {
  const login = async () => {
    if (!ProviderState.isConnectedToValidNetwork) {
      setMessage("Please connect to the correct network");
      return;
    }
    const user = await Moralis.Web3.authenticate({
      provider: window.ethereum,
      chainId: Number(config.chainId),
    });

    if (user) {
      initUser(user);
    }

    return user;
  };

  return {
    login,
    logout,
  };
};
