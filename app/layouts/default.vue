<template>
  <v-app>
    <v-app-bar elevation="1" color="surface">
        <v-img
          src="/logo.jpg"
          max-width="40"
          class="me-sm-8 ml-4"
        />
        <v-app-bar-title>PalGui</v-app-bar-title>

    </v-app-bar>

    <v-main>
      <slot />
    </v-main>
  </v-app>
</template>

<script setup lang="ts"></script>
