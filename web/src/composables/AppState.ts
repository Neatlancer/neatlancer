/* eslint-disable node/no-unpublished-import */
import { reactive, computed, ComputedRef } from "vue";
import { ProviderState } from "vue-ethers";

export interface IAppState {
  user: null | any;
  isLoading: boolean;
  isConnected: ComputedRef<boolean>;
}

export const AppState: any = reactive<IAppState>({
  user: null,
  isLoading: true,
  isConnected: computed(() => {
    return AppState.user && ProviderState.isConnectedToValidNetwork;
  }),
});
