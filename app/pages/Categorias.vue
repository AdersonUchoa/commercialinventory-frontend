<template>
  <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 max-w-5xl mx-auto mt-6 relative">
    
    <div class="flex items-center justify-between mb-8 border-b pb-4">
      <h1 class="text-2xl font-bold text-[#714B67]">Gestão de Categorias</h1>
      <Button variant="primary" @click="abrirModalCriacao">
        + Nova Categoria
      </Button>
    </div>

    <Alert :message="mensagemErro" type="error" />

    <Filter @search="aplicarFiltros" @clear="limparFiltros">
      <Input 
        v-model="filtros.searchName" 
        placeholder="Busque pelo nome..." 
      />
    </Filter>

    <Table :columns="tableColumns" :items="categorias">
      <template #col-id="{ item }">
        <span class="bg-gray-100 text-gray-600 font-mono text-xs px-2 py-1 rounded">{{ item.id }}</span>
      </template>

      <template #col-acoes="{ item }">
        <div class="space-x-1 flex justify-center opacity-0 group-hover:opacity-100 transition-opacity">
          <Button variant="text-blue" @click="prepararEdicao(item)">Editar</Button>
          <Button variant="text-red" @click="solicitarExclusao(item.id)">Excluir</Button>
        </div>
      </template>

      <template #empty>
        <svg class="mx-auto h-12 w-12 text-gray-300 mb-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
        </svg>
        Nenhuma categoria encontrada.
      </template>
    </Table>

    <Pagination 
      :current-page="paginacao.pageIndex"
      :total-pages="paginacao.totalPages"
      :total-count="paginacao.totalCount"
      :page-size="paginacao.pageSize"
      @page-change="mudarPagina"
    />

    <Modal :isOpen="modalFormAberto" @close="fecharModalForm">
      <h2 class="text-xl font-bold text-[#714B67] mb-6 border-b pb-2">
        {{ editandoId ? 'Editar Categoria' : 'Nova Categoria' }}
      </h2>

      <form @submit.prevent="salvarCategoria">
        <div class="space-y-5 mb-8">
          <Input v-model="form.nome" label="Nome da Categoria *" placeholder="Mínimo 5 caracteres" />
          <Input v-model="form.descricao" label="Descrição" placeholder="Opcional" />
        </div>
        
        <div class="flex justify-end gap-3 pt-4 border-t border-gray-100 mt-2">
          <Button variant="secondary" @click="fecharModalForm">Cancelar</Button>
          <Button type="submit" variant="primary" :disabled="!formularioValido">
            {{ editandoId ? 'Atualizar' : 'Salvar' }}
          </Button>
        </div>
      </form>
    </Modal>

    <Modal :isOpen="modalDeleteAberto" @close="modalDeleteAberto = false">
      <div class="text-center py-4">
        <div class="mx-auto flex items-center justify-center h-14 w-14 rounded-full bg-red-100 mb-4">
          <svg class="h-8 w-8 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
          </svg>
        </div>
        <h3 class="text-xl font-bold text-gray-900 mb-2">Excluir Categoria</h3>
        <p class="text-gray-500 mb-8">Tem certeza que deseja excluir esta categoria? Esta ação não pode ser desfeita.</p>

        <div class="flex justify-center gap-3">
          <Button variant="secondary" @click="modalDeleteAberto = false">Cancelar</Button>
          <Button variant="danger" @click="confirmarExclusao">Sim, Excluir</Button>
        </div>
      </div>
    </Modal>

  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useRuntimeConfig } from '#app'

const config = useRuntimeConfig()
const apiBase = config.public.apiBase

const tableColumns = [
  { key: 'id', label: 'ID', align: 'center', width: 'w-24' },
  { key: 'nome', label: 'Nome' },
  { key: 'descricao', label: 'Descrição' },
  { key: 'acoes', label: 'Ações', align: 'center', width: 'w-40' }
]

const categorias = ref([])
const form = reactive({ nome: '', descricao: '' })
const filtros = reactive({ searchName: '' })
const editandoId = ref(null)
const mensagemErro = ref('')

const modalFormAberto = ref(false)
const modalDeleteAberto = ref(false)
const idParaExcluir = ref(null)

const paginacao = reactive({
  pageIndex: 1,
  totalPages: 1,
  totalCount: 0,
  pageSize: 10
})

const formularioValido = computed(() => form.nome && form.nome.length >= 5)

const carregarDados = async (page = 1) => {
  try {
    paginacao.pageIndex = page
    let url = `${apiBase}/categorias?Page=${page}&Limit=${paginacao.pageSize}`
    
    if (filtros.searchName) {
      url += `&searchName=${encodeURIComponent(filtros.searchName)}`
    }
    
    const response = await $fetch(url)
    categorias.value = response.data?.items || []
    paginacao.totalCount = response.data?.totalCount || 0
    paginacao.totalPages = response.data?.totalPages || 1
  } catch (error) {
    console.error("Erro ao carregar categorias", error)
  }
}

const aplicarFiltros = () => carregarDados(1)
const limparFiltros = () => {
  filtros.searchName = ''
  carregarDados(1)
}
const mudarPagina = (novaPagina) => carregarDados(novaPagina)

const abrirModalCriacao = () => {
  editandoId.value = null
  form.nome = ''
  form.descricao = ''
  mensagemErro.value = ''
  modalFormAberto.value = true
}

const prepararEdicao = (categoria) => {
  editandoId.value = categoria.id
  form.nome = categoria.nome
  form.descricao = categoria.descricao || ''
  mensagemErro.value = ''
  modalFormAberto.value = true
}

const fecharModalForm = () => modalFormAberto.value = false

const salvarCategoria = async () => {
  mensagemErro.value = ''
  try {
    if (editandoId.value) {
      await $fetch(`${apiBase}/categorias/${editandoId.value}`, { method: 'PUT', body: { id: editandoId.value, ...form } })
      carregarDados(paginacao.pageIndex)
    } else {
      await $fetch(`${apiBase}/categorias`, { method: 'POST', body: form })
      carregarDados(1)
    }
    fecharModalForm()
  } catch (error) {
    mensagemErro.value = "Erro ao salvar os dados."
  }
}

const solicitarExclusao = (id) => {
  idParaExcluir.value = id
  modalDeleteAberto.value = true
}

const confirmarExclusao = async () => {
  modalDeleteAberto.value = false
  mensagemErro.value = ''
  try {
    await $fetch(`${apiBase}/categorias/${idParaExcluir.value}`, { method: 'DELETE' })
    carregarDados(paginacao.pageIndex)
  } catch (error) {
    if (error.response?.status === 409 || error.response?.status === 400) {
      mensagemErro.value = error.response._data?.message || "Não é possível excluir uma categoria vinculada a produtos."
    } else {
      mensagemErro.value = "Erro inesperado ao excluir."
    }
  }
}

onMounted(() => carregarDados())
</script>