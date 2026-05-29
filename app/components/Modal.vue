<template>
  <div v-if="isOpen" class="fixed inset-0 z-50 flex items-center justify-center">
    <div class="fixed inset-0 bg-gray-900/30 backdrop-blur-sm transition-opacity" @click="$emit('close')"></div>

    <div class="bg-white rounded-xl shadow-2xl p-6 w-full max-w-lg z-10 relative transform transition-all scale-100">
      <slot />
    </div>
  </div>
</template>

<script setup>
defineProps({ isOpen: Boolean })
defineEmits(['close'])
</script>