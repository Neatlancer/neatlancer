<script setup lang="ts">
import { useContract, getProvider } from "vue-ethers";
import { AppState } from "../composables/AppState";
import { useMoralis } from "../composables/useEthAuth";

const provider = getProvider();
const proposalManager = useContract("ProposalManager", provider);

defineProps<{ msg: string }>();

const createProposal = async (proposal: string) => {
  console.log(AppState.user);
  const proposalId = await proposalManager?.createProposal(proposal);
  return proposalId;
};

const onSubmit = () => {
  createProposal("test");
};

const { login } = useMoralis();
</script>

<template>
<div>
  <h1>{{ msg }}</h1>
  <button
    v-if="AppState.user" 
    @click="onSubmit()"
    class="bg-blue-400 hover:bg-blue-500 text-white px-5 py-2 rounded-md"> 
    Create Proposal
  </button>
  <button 
    v-else
    @click="login()"
    class="bg-blue-400 hover:bg-blue-500 text-white px-5 py-2 rounded-md"> 
    Connect
  </button>
</div>
</template>

