# Configuração do Firebase para P&R Equipamentos

## Passo 1: Criar Projeto Firebase

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Clique em "Criar um projeto"
3. Nome do projeto: `pr-equipamentos`
4. Ative o Google Analytics (opcional)

## Passo 2: Configurar Firestore Database

1. No console do Firebase, vá para "Firestore Database"
2. Clique em "Criar banco de dados"
3. Escolha "Iniciar no modo de teste" (para desenvolvimento)
4. Selecione a localização mais próxima

## Passo 3: Estrutura do Banco de Dados

### Coleções e Documentos:

#### 1. Coleção: `clientes`
```
clientes/{clienteId}
├── nome: string
├── email: string (opcional)
├── telefone: string (opcional)
├── endereco: string (opcional)
├── criadoEm: timestamp
├── atualizadoEm: timestamp
```

#### 2. Coleção: `usuarios`
```
usuarios/{usuarioId}
├── nome: string
├── email: string
├── cargo: string (opcional)
├── setor: string (opcional)
├── criadoEm: timestamp
├── atualizadoEm: timestamp
```

#### 3. Coleção: `computadores`
```
computadores/{computadorId}
├── codigo: string (P0001, P0002, ...)
├── clienteId: string (referência para clientes)
├── marca: string
├── modelo: string
├── numeroSerie: string
├── setor: string
├── operador: string
├── observacao: string (opcional)
├── fotoUrl: string (opcional)
├── criadoEm: timestamp
├── atualizadoEm: timestamp
```

#### 4. Coleção: `nobreaks`
```
nobreaks/{nobreakId}
├── codigo: string (N0001, N0002, ...)
├── clienteId: string (referência para clientes)
├── marca: string
├── modelo: string
├── numeroSerie: string
├── dataBateria: timestamp
├── modeloBateria: string
├── quantidadeBaterias: number
├── setor: string
├── observacao: string (opcional)
├── fotoUrl: string (opcional)
├── criadoEm: timestamp
├── atualizadoEm: timestamp
```

#### 5. Coleção: `contadores`
```
contadores/computadores
├── ultimo: number (último número usado para P0001, P0002...)

contadores/nobreaks
├── ultimo: number (último número usado para N0001, N0002...)
```

## Passo 4: Configurar Storage

1. No console do Firebase, vá para "Storage"
2. Clique em "Começar"
3. Aceite as regras padrão (para desenvolvimento)

### Estrutura de pastas no Storage:
```
/equipamentos/
├── computadores/
│   ├── {computadorId}/
│   │   └── foto.jpg
└── nobreaks/
    ├── {nobreakId}/
    │   └── foto.jpg
```

## Passo 5: Configurar Aplicativo Android

1. No console do Firebase, clique em "Adicionar app" > Android
2. Package name: `com.pr.equipamentos.pr_equipamentos`
3. Baixe o arquivo `google-services.json`
4. Coloque o arquivo em `android/app/google-services.json`

## Passo 6: Atualizar Configurações

1. Substitua as chaves no arquivo `lib/firebase_options.dart` pelas chaves reais do seu projeto
2. As chaves podem ser encontradas nas configurações do projeto no Firebase Console

## Regras de Segurança (Firestore)

Para desenvolvimento, use estas regras básicas:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permitir leitura e escrita para todas as coleções (apenas para desenvolvimento)
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

## Regras de Segurança (Storage)

Para desenvolvimento, use estas regras básicas:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if true;
    }
  }
}
```

**IMPORTANTE:** Estas regras são apenas para desenvolvimento. Para produção, implemente regras de segurança adequadas.

