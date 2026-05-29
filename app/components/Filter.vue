<template>
  <div class="bg-gray-50/50 rounded-lg border border-gray-200 mb-6 transition-all duration-300">
    
    <div 
      class="px-5 py-3 flex items-center justify-between cursor-pointer hover:bg-gray-100/50 transition-colors rounded-lg"
      @click="isOpen = !isOpen"
    >
      <div class="flex items-center gap-2 text-[#714B67] font-semibold">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z" />
        </svg>
        Filtros de Pesquisa
      </div>
      
      <svg 
        :class="['w-5 h-5 text-gray-400 transition-transform duration-300', isOpen ? 'rotate-180' : '']" 
        fill="none" stroke="currentColor" viewBox="0 0 24 24"
      >
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
      </svg>
    </div>
    
    <div v-show="isOpen" class="p-5 border-t border-gray-200 flex flex-col md:flex-row gap-4 md:items-center">
      
      <div class="flex-1 grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-4 items-center">
        <slot />
      </div>
      
      <div class="flex gap-2">
        <Button variant="secondary" @click="$emit('clear')">Limpar</Button>
        <Button variant="primary" @click="$emit('search')">
          <div class="flex items-center gap-2">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
            Pesquisar
          </div>
        </Button>
      </div>
      
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

defineEmits(['search', 'clear'])

const isOpen = ref(false) 
</script>