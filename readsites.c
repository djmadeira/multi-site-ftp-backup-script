#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#define MAX_DIR_LEN 50
#define MAX_LOGIN_LEN 512
#define MAX_HOST_LEN 512

struct Site {
  char dir[MAX_DIR_LEN];
  char login[MAX_LOGIN_LEN];
  char host[MAX_HOST_LEN];
};

struct Sites {
  struct Site *entries;
  int count;
};

char *consume_data(FILE *buffer, const char seperator) {
  int read = 1;
  char l = 0;
  char letter[1];

  l = fgetc(buffer);
  while (l != seperator && l != '\n' && l != EOF) {
    read++;
    l = fgetc(buffer);
  }

  char *output = malloc(sizeof(char) * read);
  fseek(buffer, read * sizeof(char) * -1L, SEEK_CUR);
  fgets(output, read, buffer);
  if (l != EOF) {
    fseek(buffer, sizeof(char) * 1L, SEEK_CUR);
  }

  return output;
}

struct Sites *get_sites(char *file_path) {
  int count = 0;
  int i = 0;
  char l = 0;

  char *mode = "r";
  FILE *sites_file = fopen(file_path, mode);

  l = fgetc(sites_file);
  while(l != EOF) {
    if (l == '\n') {
      count++;
    }
    l = fgetc(sites_file);
  }

  struct Sites *sites = malloc(sizeof(struct Sites));
  sites->count = count;
  sites->entries = malloc(count * sizeof(struct Site));

  rewind(sites_file);
  for(i = 0; i < sites->count; i++) {
    struct Site *site = &sites->entries[i];

    char *dir = consume_data(sites_file, ' ');
    char *login = consume_data(sites_file, ' ');
    char *host = consume_data(sites_file, ' ');

    strncpy(site->dir, dir, MAX_DIR_LEN);
    strncpy(site->login, login, MAX_LOGIN_LEN);
    strncpy(site->host, host, MAX_HOST_LEN);
  }

  return sites;
}

char *get_sites_list(struct Sites *sites) {
  int i = 0;
  char *sep = " ";
  char *sites_list = malloc(sites->count * MAX_DIR_LEN + (sizeof(char) * (sites->count - 1)));
  for(i = 0; i < sites->count; i++) {
    struct Site *site = &sites->entries[i];
    if (i != 0) {
      strcat(sites_list, sep);
    }
    strcat(sites_list, site->dir);
  }
  return sites_list;
}

int create_directories(struct Sites *sites) {
  int i = 0;
  int path_len = 0;
  char *folder = "backups/";
  for (i = 0; i < sites->count; i++) {
    struct stat info;
    struct Site *site = &sites->entries[i];
    path_len = strlen(folder) + strlen(site->dir) + 1;
    char *path = malloc(sizeof(char) * path_len);
    strncpy(path, folder, strlen(folder));
    strncpy(path, site->dir, strlen(site->dir));
    path[path_len - 1] = '\0';

    mkdir(site->dir, S_IRUSR | S_IWUSR | S_IXUSR);
    free(path);
  }
  return 0;
}

int main (int argc, char *argv[]) {
  char *data_file = "./sites";
  struct Sites *all_sites = get_sites(data_file);

  if (argc == 2 && argv[1][0] == 'l') {
    char *sites = get_sites_list(all_sites);
    printf("%s\n", sites);

  } else if (argc == 4 && argv[1][0] == 'g') {
    int index = atoi(argv[2]);
    if (index > all_sites->count - 1) {
      printf("Entry does not exist.\n");
      return 1;
    }
    struct Site *site = &all_sites->entries[index];
    if (argv[3][0] == 'l') {
      printf("%s\n", site->login);
    } else if(argv[3][0] == 'd') {
      printf("%s\n", site->dir);
    } else if(argv[3][0] == 'h') {
      printf("%s\n", site->host);
    }

  } else if (argc == 2 && argv[1][0] == 'd') {
    create_directories(all_sites);

  } else {
    printf("USAGE: readsites <l|g|d> [index]\n");
    return 1;
  }

  free(all_sites->entries);
  free(all_sites);

  return 0;
}