<template>
  <div v-if="message" class="mb-4 p-4 rounded border" :class="variantes[type]">
    {{ message }}
  </div>
</template>

<script setup>
const props = defineProps({
  message: String,
  type: { type: String, default: 'error' }
})

const variantes = {
  error: 'bg-red-100 text-red-700 border-red-400',
  success: 'bg-green-100 text-green-700 border-green-400'
}
</script>