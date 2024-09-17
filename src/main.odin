package main

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:slice"

media_extensions :: []string{".jpg", ".jpeg", ".webm", ".avi", ".mkv", ".png", ".gif"}

// Directory_iterator :: struct {}

// dir_iterator :: proc(it: ^Directory_iterator) -> (file: FileInfo, ok: bool) { }

run :: proc(abs_path: string) -> (err: os.Error) {
	cwd := os.open(abs_path) or_return
	defer os.close(cwd)

	files := os.read_dir(cwd, 0) or_return
	defer os.file_info_slice_delete(files)

	for f in files {
		if f.is_dir {
			run(f.fullpath) or_continue
		} else {
			ext := filepath.ext(f.name)

			if !slice.contains(media_extensions, ext) {continue}

			fmt.println(f.name, f.fullpath)
		}
	}

	return
}

main :: proc() {
	if err := run(os.args[1]); err != nil {
		fmt.eprintln(err)
		os.exit(1)
	}
}
