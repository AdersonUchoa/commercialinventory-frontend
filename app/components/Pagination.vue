<template>
  <div class="flex items-center justify-between border-t border-gray-200 bg-white px-4 py-3 sm:px-6 mt-4 rounded-lg shadow-sm">
    
    <div class="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
      <div>
        <p class="text-sm text-gray-700">
          Mostrando de <span class="font-medium">{{ totalCount === 0 ? 0 : (Number(currentPage) - 1) * Number(pageSize) + 1 }}</span> 
          a <span class="font-medium">{{ Math.min(Number(currentPage) * Number(pageSize), totalCount) }}</span> 
          de <span class="font-medium">{{ totalCount }}</span> resultados
        </p>
      </div>
      
      <div>
        <nav class="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Pagination">
          
          <button 
            type="button"
            @click.prevent="mudarPagina(Number(currentPage) - 1)" 
            :disabled="Number(currentPage) <= 1" 
            class="relative inline-flex items-center rounded-l-md px-2 py-2 text-gray-400 ring-1 ring-inset ring-gray-300 hover:bg-gray-100 hover:text-gray-700 focus:z-20 disabled:opacity-50 disabled:cursor-not-allowed cursor-pointer transition-colors"
          >
            <span class="sr-only">Anterior</span>
            &larr;
          </button>
          
          <template v-for="(page, index) in visiblePages" :key="index">
            <span v-if="page === '...'" class="relative inline-flex items-center px-4 py-2 text-sm font-semibold text-gray-700 ring-1 ring-inset ring-gray-300">...</span>
            <button 
              v-else 
              type="button"
              @click.prevent="mudarPagina(page)" 
              :class="[
                Number(page) === Number(currentPage) 
                  ? 'relative z-10 inline-flex items-center bg-white px-4 py-2 text-sm font-extrabold text-black ring-1 ring-inset ring-gray-300 focus:z-20 cursor-default' 
                  : 'relative inline-flex items-center px-4 py-2 text-sm font-semibold text-gray-900 ring-1 ring-inset ring-gray-300 hover:bg-gray-100 hover:text-[#017E84] focus:z-20 cursor-pointer transition-colors'
              ]"
            >
              {{ page }}
            </button>
          </template>

          <button 
            type="button"
            @click.prevent="mudarPagina(Number(currentPage) + 1)" 
            :disabled="Number(currentPage) >= Number(totalPages)" 
            class="relative inline-flex items-center rounded-r-md px-2 py-2 text-gray-400 ring-1 ring-inset ring-gray-300 hover:bg-gray-100 hover:text-gray-700 focus:z-20 disabled:opacity-50 disabled:cursor-not-allowed cursor-pointer transition-colors"
          >
            <span class="sr-only">Próximo</span>
            &rarr;
          </button>
          
        </nav>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  currentPage: { type: [Number, String], required: true },
  totalPages: { type: [Number, String], required: true },
  totalCount: { type: [Number, String], required: true },
  pageSize: { type: [Number, String], default: 10 }
})

const emit = defineEmits(['page-change'])

const visiblePages = computed(() => {
  const current = Number(props.currentPage)
  const total = Number(props.totalPages)
  
  if (total === 0) return [1]
  
  if (total <= 7) return Array.from({ length: total }, (_, i) => i + 1)
  if (current <= 4) return [1, 2, 3, 4, 5, '...', total]
  if (current >= total - 3) return [1, '...', total - 4, total - 3, total - 2, total - 1, total]
  
  return [1, '...', current - 1, current, current + 1, '...', total]
})

const mudarPagina = (page) => {
  const alvo = Number(page)
  const atual = Number(props.currentPage)
  const total = Number(props.totalPages)

  if (alvo !== atual && alvo >= 1 && alvo <= total) {
    emit('page-change', alvo)
  }
}
</script>