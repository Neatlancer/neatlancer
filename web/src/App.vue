<script setup lang="ts">
// This starter template is using Vue 3 <script setup> SFCs
// Check out https://v3.vuejs.org/api/sfc-script-setup.html#sfc-script-setup
import { MoralisProvider, AuthState, DappProvider } from 'vue-ethers';
import CreateProposal from './components/CreateProposal.vue'
import { config } from './config';
import { contracts } from "../contracts.json"
import LandingHeader from './layout/LandingHeader.vue';
const provider = MoralisProvider(AuthState, config);

</script>

<template>
  <DappProvider :provider="provider" :config="config" :contracts="contracts">
    <LandingHeader />
    <CreateProposal msg="Hello Vue 3 + TypeScript + Vite" />
  </DappProvider>
</template>
