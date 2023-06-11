#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <pwd.h>
#include <grp.h>
#include <time.h>
#include <errno.h>
#include <string.h>

void listFiles(const char* path, int long_format, int recursive);

int main(int argc, char* argv[]) {
    int recursive = 0;
    int long_format = 0;

    // Check command line arguments
    if (argc > 1 && strcmp(argv[1], "-l") == 0) {
        long_format = 1;
    }

    if (argc > 1 && strcmp(argv[1], "-R") == 0) {
        recursive = 1;
    }

    if (argc > 1 && strcmp(argv[1], "-lR") == 0) {
            long_format = 1;
            recursive = 1;
    }

    listFiles(".", long_format, recursive);

    return 0;
}

void listFiles(const char* path, int long_format, int recursive) {
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

    while ((entry = readdir(dir)) != NULL) {

        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
                continue;
        }

        char filepath[PATH_MAX];
        snprintf(filepath, PATH_MAX, "%s/%s", path, entry->d_name);

        if (stat(filepath, &file_stats) != 0) {
                fprintf(stderr, "Cannot get file stats for '%s': %s\n", entry->d_name, strerror(errno));
            continue;
        }

        pw = getpwuid(file_stats.st_uid);
        gr = getgrgid(file_stats.st_gid);

        if (long_format) {

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
        printf("\t%s\t%s\t%lld\t%s\t%s\n", pw->pw_name, gr->gr_name, (long long)file_stats.st_size, date, entry->d_name);

        }
        else {
                printf("%s\n", entry->d_name);
        }

        if (recursive && S_ISDIR(file_stats.st_mode) && strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0) {
            char subdir[PATH_MAX];
            snprintf(subdir, PATH_MAX, "%s/%s", path, entry->d_name);
                listFiles(subdir, long_format, recursive);
        }
    }

    closedir(dir);
}
