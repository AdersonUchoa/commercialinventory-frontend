<template>
  <button 
    :type="type" 
    :disabled="disabled"
    :class="[
      'px-4 py-2 rounded-lg transition-all duration-200 font-medium focus:outline-none cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center',
      variantes[variant]
    ]"
  >
    <slot />
  </button>
</template>

<script setup>
const props = defineProps({
  type: { type: String, default: 'button' },
  disabled: { type: Boolean, default: false },
  variant: { type: String, default: 'primary' }
})

const variantes = {
  primary: 'bg-[#017E84] text-white hover:bg-[#015A5E] shadow-sm hover:shadow-md',
  secondary: 'bg-gray-100 text-gray-700 hover:bg-gray-200',
  danger: 'bg-red-600 text-white hover:bg-red-700 shadow-sm hover:shadow-md',
  'text-blue': 'text-[#017E84] hover:text-[#015A5E] bg-transparent px-2 py-1 hover:bg-[#017E84]/10 rounded',
  'text-red': 'text-red-500 hover:text-red-700 bg-transparent px-2 py-1 hover:bg-red-50 rounded'
}
</script>