<template>
  <NuxtLink 
    :to="to" 
    class="group flex items-start p-6 bg-white rounded-2xl shadow-sm border border-gray-100 hover:border-[#017E84] hover:shadow-md transition-all duration-300 cursor-pointer"
  >
    <div class="flex-shrink-0 bg-[#017E84]/10 p-4 rounded-xl group-hover:bg-[#017E84] transition-colors duration-300">
      <slot name="icone"></slot>
    </div>
    <div class="ml-5 text-left">
      <h2 class="text-xl font-bold text-gray-800 group-hover:text-[#017E84] transition-colors duration-300">
        {{ titulo }}
      </h2>
      <p class="mt-1 text-sm text-gray-500">
        {{ descricao }}
      </p>
    </div>
  </NuxtLink>
</template>

<script setup>
defineProps({
  to: {
    type: String,
    required: true
  },
  titulo: {
    type: String,
    required: true
  },
  descricao: {
    type: String,
    required: true
  }
})
</script>