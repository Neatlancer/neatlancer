<script lang="ts" setup>
import { AtField, AtInput, AtButton, useForm, AtDateSelect } from "atmosphere-ui";
import { computed } from "vue";
import { Address } from "vue-ethers";
import exactMath from "exact-math";
import ProposalSummaryItem from "./ProposalSummaryItem.vue";
import { IPayment, IService } from "../../types";

const props = defineProps({
    address: {
        type: String,
        required: true,
    },
});

const emit = defineEmits(['submit', 'cancel']);

const form = useForm({
    client: props.address,
    services: [{
        name: '',
        description: '',
        price: 0,
        qty: 1,
    }],
    paymentSchedule: [{
        amount: 0,
        date: '',
        status: 0,
    }],
});

const saveProposal = async () => {
    emit('submit', form.data());
};

const cancel = () => {
    form.reset();
    emit('cancel');
};

const grandTotal = computed(() => {
    const subtotal = form.services.reduce((sum: number, service: IService ) => {
        sum += exactMath.mul(service.price, service.qty);
        return sum;
    }, 0);

    const taxes = 0;

    return {
        subtotal,
        taxes,
        total: exactMath.add(subtotal, taxes),
    }
});

const paymentTotal = computed(() => {
    const scheduled = form.paymentSchedule.reduce((sum: number, payment: IPayment ) => {
        sum = exactMath.add(sum, payment.amount);
        return sum;
    }, 0);

    const paid = form.paymentSchedule.reduce((sum: number, payment: IPayment ) => {
        if (payment.status) {
            sum = exactMath.add(sum, payment.amount);
        }
        return sum;
    }, 0);


    return {
        scheduled,
        paid,
        pending: exactMath.sub(scheduled, paid),
    }
});

const addService = () => {
    form.services.push({
        name: '',
        description: '',
        price: 0,
        qty: 1,
    });
};

const addPayment = () => {
    form.paymentSchedule.push({
        amount: paymentTotal.value.pending,
        date: '',
        status: 0,
    });
};

const checkAmountFor = (index: number) => {
    if (!form.paymentSchedule[index].amount) {
        form.paymentSchedule[index].amount = paymentTotal.value.pending;
    }
};
</script>

<template>
<div class="text-left text-gray-600">
    <div class="flex justify-between">
        <h1 class="text-xl font-bold">New Proposal</h1>
        <div class="flex space-x-2">
            <AtButton class="bg-primary text-white" @click.prevent="saveProposal()">Create Proposal</AtButton>
            <AtButton class="font-bold bg-gray-300" @click.prevent="cancel()">Cancel</AtButton>
        </div>
    </div>
    <div class="flex px-5 py-10 mt-5 text-white bg-teal-400 rounded-md">
        <span class="font-bold">Client:</span> 
        <Address :address="address" :size="4" /> </div>
    <div class="mt-10 text-center">
        <h4 class="text-xl font-bold text-left">Items</h4>
        <div class="flex mt-2 border-b-2 border-gray-400">
            <div v-for="col in ['Service', 'Qty', 'Price', 'Total']" class="w-full">
                {{ col}}
            </div>
        </div>
        <div class="flex py-2 space-x-1 border-b" v-for="service in form.services">
            <AtField field="name" label="">
                <AtInput v-model="service.name" class="border-none shadow-none" placeholder="Service name"/>
            </AtField>
            <AtField field="qty" label="">
                <AtInput v-model="service.qty" class="border-none shadow-none" />
            </AtField>
            <AtField field="price" label="">
                <AtInput v-model="service.price" class="border-none shadow-none" />
            </AtField>
            <AtField field="total" label="" >
                <div>
                    {{ service.price * service.qty }}
                </div>
            </AtField>
        </div>
        <AtButton class="font-bold text-primary" @click.prevent="addService">Add item</AtButton>
    </div>

    <div class="flex justify-end">
        <div>
            <ProposalSummaryItem  label="Subtotal" :value="grandTotal.subtotal" />
            <ProposalSummaryItem  label="Taxes" :value="grandTotal.taxes" />
            <ProposalSummaryItem  label="Total" :value="grandTotal.total" />
        </div>
    </div>
    <div class="mt-10 text-center">
        <h4 class="text-xl font-bold text-left">Payment Schedule </h4>
        <div class="flex mt-2 border-b-2 border-gray-400">
            <div v-for="col in ['Amount', 'When', 'status']" class="w-full">
                {{ col}}
            </div>
        </div>
        <div class="flex py-2 space-x-1 border-b" v-for="(payment, index) in form.paymentSchedule">
            <AtField field="amount" label="" class="w-full">
                <AtInput 
                    v-model="payment.amount" 
                    class="border-none shadow-none" 
                    placeholder="Service name"
                    :click="checkAmountFor(index)"
                />
            </AtField>
            <AtField field="date" label="" class="w-full">
                <AtDateSelect v-model="payment.date" class="border-none shadow-none" />
            </AtField>
            <AtField field="total" label="" class="w-full min-w-12 text-center">
                Upcomming
            </AtField>
        </div>
        <AtButton class="font-bold text-primary" @click.prevent="addPayment">Add payment</AtButton>
    </div>
</div>
</template>