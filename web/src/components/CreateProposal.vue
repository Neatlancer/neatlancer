<script setup lang="ts">
import { ethers } from "ethers";
import {  reactive, watchEffect } from "vue";
import { useContract, getProvider, ProviderState, useEthAuth } from "vue-ethers";

const provider = getProvider();
const proposalManager = useContract("ProposalManager", provider);
const { login, AuthState } = useEthAuth();
defineProps<{ msg: string }>();

const form = reactive({
  address: ""
});

const createProposal = async (proposal: string) => {
  const paymentSchedule = [
    {
      amount: ethers.utils.parseEther("1"),
      paymentDate: new Date().getTime(),
    },
  ];

  if (!ProviderState.signer) return; 
  const proposalId = await proposalManager?.connect(ProviderState.signer).createProposal(
    new Date().getTime(),
    form.address,
    "Neatlancer",
    "Project for blockchain",
    paymentSchedule

  );
  await fetchProposals();
  return proposalId;
};

const onSubmit = () => {
  createProposal("test");
};

const state = reactive({
  proposals: [],
  proposalCount: 0,
});

const fetchProposals = async () => {
  console.log(ProviderState.account);
  try {
    const proposals = await proposalManager?.getProposalsBy(ProviderState.account);
    state.proposals = proposals;
    state.proposalCount = proposals.length;
  } catch (err) {
    console.error(err);
  }
};

watchEffect(() => {
  if (ProviderState.account) {
    fetchProposals();
  }
});

</script>

<template>
<div class="text-center">
  <h1>{{ msg }}</h1>
  <div>
  {{ state.proposalCount }} Proposals
  </div>
  <div v-for="proposal in state.proposals">
    {{ proposal }}
  </div>
  <form  v-if="AuthState.user"  @submit.prevent="onSubmit()">
    <input v-model="form.address">
    <button
      @click="onSubmit()"
      class="px-5 py-2 text-white bg-blue-400 rounded-md hover:bg-blue-500"> 
      Create Proposal
    </button>
  </form>
  <button 
    v-else
    @click="login()"
    class="px-5 py-2 text-white bg-blue-400 rounded-md hover:bg-blue-500"> 
    Connect
  </button>
</div>
</template>

