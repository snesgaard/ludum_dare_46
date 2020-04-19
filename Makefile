title=torch_in_the_cave

play:
	make -C art
	love . sprite

release:
	rm -f $(title).love
	rm -rf $(title)
	rm -f $(title).zip
	zip -9 -r $(title).love .
	cp -r release_scripts $(title)
	mv $(title).love $(title)
	zip -9 -r $(title).zip $(title)
