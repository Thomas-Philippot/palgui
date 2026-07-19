<script setup lang="ts">

const emits = defineEmits(['done'])

const message = ref('')

const props = defineProps({
  player: {
    type: Object,
    required: true
  }
})

const sendAction = (endpoint: string) => {
  const { error } = useFetch(`/api/pal/${endpoint}`, {
    method: 'POST',
    body: {
      userId: props.player.userId,
      message: message.value
    }
  })
  if (!error.value) {
    message.value = ''
    emits('done')
  }
}

</script>

<template>
    <v-dialog max-width="500">
    <template #activator="{ props: activatorProps }">
        <v-btn
        v-bind="activatorProps"
        color="secondary"
        prepend-icon="mdi-gavel"
        text="Moderation"
        variant="outlined"
        ></v-btn>
    </template>

    <template #default="{ isActive }">
        <v-card>
            <v-card-title>Moderation</v-card-title>
            <v-card-subtitle>
                {{ player.name }}
            </v-card-subtitle>
            <v-card-text>
                <v-textarea v-model="message" label="Message" />
            </v-card-text>

            <v-card-actions>
                <v-btn
                text="Close"
                @click="isActive.value = false"
                ></v-btn>
                <v-spacer />
                <v-btn @click="sendAction('unban')" variant="outlined" color="info">
                    Unban
                </v-btn>
                <v-btn @click="sendAction('kick')" variant="tonal" color="warning">
                    Kick
                </v-btn>
                <v-btn @click="sendAction('ban')" variant="tonal" color="error">
                    Ban
                </v-btn>
            </v-card-actions>
        </v-card>
    </template>
    </v-dialog>
</template>
