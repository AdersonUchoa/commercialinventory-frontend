<template>
  <div class="flex flex-col items-center justify-center mt-12 md:mt-24">
    
    <div class="text-center mb-12">
      <h1 class="text-4xl md:text-5xl font-extrabold text-[#714B67] mb-4 tracking-tight">
        Inventário Comercial
      </h1>
      <p class="text-lg text-gray-500 max-w-xl mx-auto">
        Selecione um dos módulos abaixo para gerenciar o catálogo do seu sistema de forma rápida e centralizada.
      </p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 w-full max-w-4xl px-4">
      
      <Card 
        to="/categorias" 
        titulo="Categorias" 
        descricao="Gerencie as categorias do sistema."
      >
        <template #icone>
          <svg class="w-8 h-8 text-[#017E84] group-hover:text-white transition-colors duration-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
          </svg>
        </template>
      </Card>

      <Card 
        to="/produtos" 
        titulo="Produtos" 
        descricao="Gerencie os produtos do sistema."
      >
        <template #icone>
          <svg class="w-8 h-8 text-[#017E84] group-hover:text-white transition-colors duration-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
          </svg>
        </template>
      </Card>

    </div>
  </div>
</template>

<script setup>
</script>