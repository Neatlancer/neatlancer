<script lang="ts" setup>
    defineProps({
        label: {
            type: String,
            required: true,
        },
        value: {
            type: [String, Number],
        }
    })
</script>

<template>
    <div class="flex items-center justify-between space-x-20">
        <div> {{ label }}</div>
        <div> {{ value }}</div>
    </div>
</template>
