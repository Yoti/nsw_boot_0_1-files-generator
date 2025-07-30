#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
	if ((argc < 3) || (argc > 4)) {
		printf("hextool ver 20250729 by Yoti\n");
		printf("usage: out_file file_size\n");
		printf("usage: out_file offset in_file\n");
		return 1;
	} else {
		unsigned char fon[255]; // file output name
		memset(&fon, 0, strlen(fon));
		FILE *fof; // file output file

		strcat(fon, &argv[1][0]);

		int ofs = 0; // file size or offset
		static unsigned char fb[4*1024*1024]; // file buf
		memset(&fb, 0, sizeof(fb));
		ofs = strtol(argv[2], NULL, 16);
		if (argc == 3) {
			if ((fof = fopen(fon, "wb")) == NULL) {
				return 2;
			}
			fwrite(fb, 1, ofs, fof); // file size
		} else {
			if ((fof = fopen(fon, "rwb+")) == NULL) {
				return 2;
			}
			fseek(fof, ofs, SEEK_SET); // file offset

			unsigned char fin[255]; // file input name
			memset(&fin, 0, strlen(fin));
			FILE *fif; // file input file

			strcat(fin, &argv[3][0]);
			if ((fif = fopen(fin, "rb")) == NULL) {
				return 3;
			}

			fseek(fif, 0, SEEK_END);
			int ifs = ftell(fif);
			fseek(fif, 0, SEEK_SET);

			fread(fb, 1, ifs, fif);
			fwrite(fb, 1, ifs, fof);

			fclose(fif);
		}

		fclose(fof);
	}

	return 0;
}
