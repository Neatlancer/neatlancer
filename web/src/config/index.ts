/* eslint-disable node/no-missing-import */
/* eslint-disable node/no-unpublished-import */
import { useSecureString } from "../../../_shared/useSecureString";
const { getEnv } = useSecureString(import.meta.env);

export const config = {
  rpcURL: getEnv("VITE_RPC_URL", "http://localhost:8545"),
  chainId: getEnv("VITE_CHAIN_ID", "1337"),
  moralisServerUrl: getEnv("VITE_MORALIS_SERVER_URL"),
  moralisKey: getEnv("VITE_MORALIS_API_KEY", ""),
};

console.log(config);
