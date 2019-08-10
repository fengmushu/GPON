
.PHONY: all osgi h3

STAMP := $(shell date +%Y%m%d%H%M%S)

all:
	@echo "make h3|osgi"

osgi:
	./makeself/makeself.sh --gzip --nomd5 --nocrc --nowctr \
					hotfix-osgi/ hotfix-osgi-$(STAMP).run \
					"osgi-hproxy" ./startup.sh

h3:
	./makeself/makeself.sh --gzip --nowctr \
					hotfix-h3/ hotfix-h3-$(STAMP).run \
					"hotfix-h3" ./startup.sh
