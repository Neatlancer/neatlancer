<script setup lang="ts">
import { ethers } from "ethers";
import {  reactive, watchEffect } from "vue";
import { useContract, ProviderState, useEthAuth } from "vue-ethers";
import { AtButton, AtInput } from "atmosphere-ui";

const proposalManager = useContract("ProposalManager");
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
    const proposals = await proposalManager?.getProposalsBy(ProviderState.account);
    state.proposals = proposals;
    state.proposalCount = proposals.length;
};

watchEffect(() => {
  if (ProviderState.account) {
    fetchProposals();
  } else {
    state.proposals = [];
    state.proposalCount = 0;
  }
});

</script>

<template>
<div class="text-center">
  <form  v-if="AuthState.user"  @submit.prevent="onSubmit()" class="max-w-xl mx-auto">
    <div class="flex px-5">
      <AtInput v-model="form.address" class="rounded-r-none focus:shadow-primary focus:ring-primary" />
      <AtButton class="w-64 text-white rounded-l-none bg-primary"> Create Proposal</AtButton>
    </div>
  </form>
  <AtButton 
    v-else
    @click="login()"
    class="text-white bg-primary"> 
    Connect
  </AtButton>
</div>
</template>

