<template>
  <div class="bg-white rounded-lg overflow-hidden border border-gray-200">
    <table class="w-full text-left border-collapse">
      <thead>
        <tr class="bg-gray-50 text-gray-600 text-sm uppercase tracking-wider border-b border-gray-200">
          <th 
            v-for="col in columns" 
            :key="col.key" 
            :class="['p-4 font-semibold', col.align ? `text-${col.align}` : 'text-left', col.width]"
          >
            {{ col.label }}
          </th>
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-100">
        <tr v-for="item in items" :key="item.id" class="hover:bg-[#F3F4F6] transition-colors group">
          <td 
            v-for="col in columns" 
            :key="col.key" 
            :class="['p-4', col.align ? `text-${col.align}` : 'text-left']"
          >
            <slot :name="`col-${col.key}`" :item="item">
              <span class="text-gray-800">{{ item[col.key] || '—' }}</span>
            </slot>
          </td>
        </tr>
        
        <tr v-if="!items || items.length === 0">
           <td :colspan="columns.length" class="p-12 text-center text-gray-400">
             <slot name="empty">
                Nenhum registro encontrado.
             </slot>
           </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
defineProps({
  columns: {
    type: Array,
    required: true,
  },
  items: {
    type: Array,
    required: true
  }
})
</script>