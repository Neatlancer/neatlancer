<script lang="ts" setup>
import { AtSiteHeader } from "atmosphere-ui";
import { useEthAuth, AccountButton } from "vue-ethers";
const { AuthState, login, logout } = useEthAuth();

const links = [{
    name: 'Home',
    to: '/',
}, {
    name: 'Claim',
    url: '/#claim'
}, {
    name: 'Dashboard',
    to: '/dashboard',
}];

const actions = [{
    name: 'Learn more',
    url: '/login',
    class: 'text-primary-500'
}, {
    name: 'Connect',
    emit: true,
    class: "relative px-5 py-2 overflow-hidden rounded-md focus:outline-none hover:bg-primary-700 px-10 font-bold text-white bg-primary-500"
}]

const menuOptions = {
      account: {
        label: "General options",
        sections: [
          ["Profile", "/settings/profile"],
          ["Favorites", "/favorites"],
          ["My Collection", "/my-items"],
          ["Favorites", "/settings"],
          ["Logout", { emit: 'logout', separator: true }],
        ]
      }
    }
</script>

<template>
<div class="mb-10 bg-white shadow-md text-primary">
    <AtSiteHeader 
        title="Neatlancer" 
        :links="links" 
        :actions="actions" 
        dot-class="text-transparent" 
        link-class="text-primary hover:text-primary-600"
        @action="login" 
    >
        <template #actions v-if="AuthState.user" >
            <AccountButton :options="menuOptions"  class="text-red-500" @logout="logout()" />
        </template>
    </AtSiteHeader>
</div>
</template>