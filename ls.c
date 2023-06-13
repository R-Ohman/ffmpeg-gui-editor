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
	
	printPermissions(statbuf->st_mode);
	
	char date[20];
	
	strftime(date, 20, "%b %d %H:%M", localtime(&(statbuf->st_ctime)));
	printf(" \t%s\t%s\t%lld\t%s\t%s\n", pw->pw_name, grp->gr_name, (long long)statbuf->st_size, date, filename);
}


void listFiles(const char* path, int recursive, int long_format);

int main(int argc, char* argv[]) {
    int recursive = 0;
    int long_format = 0;

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
	
    if (strcmp(path, ".") != 0 && strcmp(path, "./") != 0) {
   	 printf("\n%s:\n", path);
    	}

    while ((entry = readdir(dir)) != NULL) {
        char filepath[PATH_MAX];
        snprintf(filepath, PATH_MAX, "%s/%s", path, entry->d_name);

        if (stat(filepath, &file_stats) < 0) {
            	printf("Unable to get file stat: %s\n", filepath);
		continue;
        }

	if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
		continue;
	}

        if (long_format) {
            printFileInfo(entry->d_name, &file_stats);
        }
	else if (!(recursive && S_ISDIR(file_stats.st_mode))) {
	        printf("%s\t", entry->d_name);
	}


        if (recursive && S_ISDIR(file_stats.st_mode) && strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0
	) {	
		listFiles(filepath, recursive, long_format);
        }
    }
    printf("\n");

    closedir(dir);
}

