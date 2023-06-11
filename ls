#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <sys/stat.h>
#include <pwd.h>
#include <grp.h>
#include <time.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>

void printPermissions(mode_t st_mode) {
        printf((S_ISDIR(st_mode)) ? "d" : "-");
        printf((st_mode & S_IRUSR) ? "r" : "-");
        printf((st_mode & S_IWUSR) ? "w" : "-");
        printf((st_mode & S_IXUSR) ? "x" : "-");
        printf((st_mode & S_IRGRP) ? "r" : "-");
        printf((st_mode & S_IWGRP) ? "w" : "-");
        printf((st_mode & S_IXGRP) ? "x" : "-");
        printf((st_mode & S_IROTH) ? "r" : "-");
        printf((st_mode & S_IWOTH) ? "w" : "-");
        printf((st_mode & S_IXOTH) ? "x" : "-");
}

void printFileInfo(const char* filename, const struct stat* statbuf) {
        struct passwd* pw = getpwuid(statbuf->st_uid);
        struct group* grp = getgrgid(statbuf->st_gid);
        /*
        printf("%s ", filename);
        printf("%ld ", statbuf->st_size);

        // Print file permissions
        printPermissions(statbuf->st_mode);
        printf(" ");

        // Print number of hard links
        printf("%ld ", statbuf->st_nlink);

        // Print owner and group
        printf("%s ", pw->pw_name);
        printf("%s ", grp->gr_name);

        // Print last modified time
        char time_buffer[80];
        strftime(time_buffer, sizeof(time_buffer), "%b %d %H:%M", localtime(&statbuf->st_mtime));
        printf("%s ", time_buffer);
        printf("\n");
*/
        printPermissions(statbuf->st_mode);
        char date[20];
        strftime(date, 20, "%b %d %H:%M", localtime(&(statbuf->st_ctime)));
        printf(" \t%s\t%s\t%lld\t%s\t%s\n", pw->pw_name, grp->gr_name, (long long)statbuf->st_size, date, filename);
}

void traverseDirectory(const char* path) {
        DIR* dir;
        struct dirent* entry;
        struct stat statbuf;

        dir = opendir(path);
        if (dir == NULL) {
                perror("opendir");
                return;
        }

        while ((entry = readdir(dir)) != NULL) {
                char fullpath[1024];
                snprintf(fullpath, sizeof(fullpath), "%s/%s", path, entry->d_name);

                if (lstat(fullpath, &statbuf) == -1) {
                        perror("lstat");
                        continue;
                }


                if (S_ISDIR(statbuf.st_mode)) {
                        // Skip "." and ".." directories
                     if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
                             continue;
                     }
                     printf("%s:\n", fullpath);
                     traverseDirectory(fullpath);
                } else {
                        printFileInfo(entry->d_name, &statbuf);
                }
        }
        closedir(dir);
}




void listFiles(const char* path, int recursive, int long_format);

int main(int argc, char* argv[]) {
    int recursive = 0;
    int long_format = 0;

        // Check command line arguments
    if (argc > 1) {
        for (int i = 1; i < argc; i++) {
            if (strcmp(argv[i], "-l") == 0) {
                long_format = 1;
            } else if (strcmp(argv[i], "-R") == 0) {
                recursive = 1;
            } else if (strcmp(argv[i], "-lR") == 0) {
                recursive = 1;
                long_format = 1;
            }
        }
    }

        const char* path = ".";

    //traverseDirectory(path);
    listFiles(path, recursive, long_format);

    return 0;
}

void listFiles(const char* path, int recursive, int long_format) {
    DIR *dir;
    struct dirent *entry;
    struct stat file_stats;
    struct passwd *pw;
    struct group *gr;

    dir = opendir(path);
    if (dir == NULL) {
        fprintf(stderr, "opendir() failed for directory '%s'\n", path);
        return;
    }

    printf("%s:\n", path);

    while ((entry = readdir(dir)) != NULL) {
        char filepath[PATH_MAX];
        snprintf(filepath, PATH_MAX, "%s/%s", path, entry->d_name);

        if (stat(filepath, &file_stats) < 0) {
                printf("Unable to get file stat: %s\n", filepath);
                continue;
        }

        if (long_format) {
            printFileInfo(entry->d_name, &file_stats);
        /*pw = getpwuid(file_stats.st_uid);
            gr = getgrgid(file_stats.st_gid);

            printf((S_ISDIR(file_stats.st_mode)) ? "d" : "-");
            printf((file_stats.st_mode & S_IRUSR) ? "r" : "-");
            printf((file_stats.st_mode & S_IWUSR) ? "w" : "-");
            printf((file_stats.st_mode & S_IXUSR) ? "x" : "-");
            printf((file_stats.st_mode & S_IRGRP) ? "r" : "-");
            printf((file_stats.st_mode & S_IWGRP) ? "w" : "-");
            printf((file_stats.st_mode & S_IXGRP) ? "x" : "-");
            printf((file_stats.st_mode & S_IROTH) ? "r" : "-");
            printf((file_stats.st_mode & S_IWOTH) ? "w" : "-");
            printf((file_stats.st_mode & S_IXOTH) ? "x" : "-");

            char date[20];
            strftime(date, 20, "%b %d %H:%M", localtime(&(file_stats.st_ctime)));

            printf("\t%ld\t%s\t%s\t%s\n", file_stats.st_size, date, pw->pw_name, gr->gr_name);
            */
        }
        else {
                printf("%s\n", entry->d_name);
        }


        if (recursive && S_ISDIR(file_stats.st_mode) && strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0) {
listFiles(filepath, recursive, long_format);
        }
    }

    closedir(dir);
}
