<script setup lang="ts">
import ModerationDialog from '~/components/ModerationDialog.vue'

const { data: serverInfo, status: serverInfoStatus } = await useFetch('/api/pal/info')
const { data: serverMetrics, status: serverMetricsStatus } = await useFetch('/api/pal/metrics')
const { data: serverPlayers, status: serverPlayersStatus } = await useFetch('/api/pal/players')

const announceMessage = ref('')
const snackbar = ref(false)
const snackText = ref('')
const snackColor = ref('info')

const formatUptime = (seconds: number) => {
  if (!seconds) return 'Unknown'

  const days = Math.floor(seconds / 86400)
  const hours = Math.floor((seconds % 86400) / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)

  const parts = []
  if (days > 0) parts.push(`${days}d`)
  if (hours > 0) parts.push(`${hours}h`)
  if (minutes > 0) parts.push(`${minutes}m`)

  return parts.length > 0 ? parts.join(' ') : '0m'
}

const sendToast = (message: string, color: string) => {
  snackText.value = message
  snackColor.value = color
  snackbar.value = true
}

const sendAnnounce = () => {
  const { error } = useFetch('/api/pal/announce', {
    method: 'POST',
    body: {
      message: announceMessage
    }
  })
  if (!error.value) {
    announceMessage.value = ''
    sendToast('Announce sent', 'success')
  }
}

</script>

<template>
  <v-container>
    <v-row>
        <v-col v-if="serverInfoStatus === 'pending'">
            <v-skeleton-loader type="list-item-two-line" />
        </v-col>
        <v-col v-if="serverInfo">
            <div class="text-headline-medium font-weight-bold text-sm-headline-large">
                {{ serverInfo.servername }}
            </div>
            <div class="mt-4 mb-4 text-body-large text-medium-emphasis">
              {{ serverInfo.description }}
              <v-chip class="mx-2" size="small" color="secondary">
                  {{ serverInfo.version }}
              </v-chip>
            </div>
        </v-col>
    </v-row>
    <v-row v-if="serverMetricsStatus === 'pending'">
        <v-col v-for="x in 4">
            <v-skeleton-loader type="image" />
        </v-col>
    </v-row>
    <v-row v-if="serverMetrics">
        <v-col>
            <v-card prepend-icon="mdi-account" title="Players">
                <v-card-text>
                    <v-row align="center">
                        <v-col>
                            <v-progress-linear
                                v-model="serverMetrics.currentplayernum"
                                color="primary"
                                rounded
                                height="8"
                                :max="serverMetrics.maxplayernum"
                            />
                        </v-col>
                        <v-col cols="3">
                            {{ serverMetrics.currentplayernum }} / {{ serverMetrics.maxplayernum }}
                        </v-col>
                    </v-row>
                </v-card-text>
            </v-card>
        </v-col>
        <v-col>
            <v-card prepend-icon="mdi-clock" title="Uptime">
                <v-card-text>
                    {{ formatUptime(serverMetrics?.uptime) }}
                </v-card-text>
            </v-card>
        </v-col>
        <v-col>
            <v-card prepend-icon="mdi-weather-sunset" title="Days">
                <v-card-text>
                    {{ serverMetrics.days }}
                </v-card-text>
            </v-card>
        </v-col>
        <v-col>
            <v-card prepend-icon="mdi-campfire" title="Basecamp">
                <v-card-text>
                    {{ serverMetrics.basecampnum }}
                </v-card-text>
            </v-card>
        </v-col>
    </v-row>
    <v-row>
        <v-col>
            <v-card>
                <v-card-text>
                    <v-skeleton-loader v-if="serverPlayersStatus === 'pending'" type="list-item-two-line@6" />
                    <v-list v-if="serverPlayers">
                        <v-list-subheader>Online Players</v-list-subheader>
                        <v-list-item v-for="player in serverPlayers.players" :key="player.playerId"">
                            <v-list-item-title>
                                <div class="text-title-medium">{{ player.name }}</div>
                            </v-list-item-title>
                            <v-list-item-subtitle>
                                Level {{ player.level }}
                                <v-chip class="mx-1" size="x-small" color="info">
                                    {{ player.iP }}
                                </v-chip>
                            </v-list-item-subtitle>
                            <template #append>
                                <moderation-dialog :player="player" @done="sendToast('Action sent', 'success')" />
                            </template>
                        </v-list-item>
                    </v-list>
                    <v-divider />
                    <v-row class="mt-6" align="baseline">
                        <v-col>
                            <v-text-field
                                v-model="announceMessage"
                                variant="outlined"
                                label="annonce message"
                            />
                        </v-col>
                        <v-col cols="1">
                            <v-btn color="primary" @click="sendAnnounce">Send</v-btn>
                        </v-col>
                    </v-row>
                </v-card-text>
            </v-card>
        </v-col>
    </v-row>
    <v-snackbar
      v-model="snackbar"
      timeout="2000"
      :color="snackColor"
    >
      {{ snackText }}
    </v-snackbar>
  </v-container>
</template>
