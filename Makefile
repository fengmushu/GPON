
X_FLAGS := --gzip --nomd5 --nocrc --nowctr
X_LABLE := "osgi-hproxy"

all:
	./makeself/makeself.sh $(X_FLAGS) hotfix/ hotfix.run $(X_LABLE) ./startup.sh
