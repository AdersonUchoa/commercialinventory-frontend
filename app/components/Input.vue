<template>
  <div>
    <label v-if="label" class="block text-sm font-medium mb-1 text-gray-700">{{ label }}</label>
    <input 
      :value="modelValue"
      @input="$emit('update:modelValue', $event.target.value)"
      :type="type" 
      :placeholder="placeholder"
      class="w-full border rounded p-2 focus:outline-blue-500 bg-white disabled:bg-gray-100" 
    />
  </div>
</template>

<script setup>
defineProps({
  modelValue: [String, Number],
  label: String,
  type: { type: String, default: 'text' },
  placeholder: String
})
defineEmits(['update:modelValue'])
</script>