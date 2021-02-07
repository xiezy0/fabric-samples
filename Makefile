ENVVARS   =

envvar-%:
	$(if $(value $*),,$(error $* is not set))

.PHONY: check-env
check-env: $(patsubst %, envvar-%, $(ENVVARS))

.PHONY: fabcar
fabcar: check-env
	@echo Start the chain with Fabcar
	./scripts/ci_scripts/test_fabcar.sh ./startFabric.sh

.PHONY: fabcar-stop
fabcar-clean:
	@echo Clean all with Fabcar
	./scripts/ci_scripts/test_fabcar.sh ./stopFabric.sh

.PHONY: sdk-test
sdk-test:
	./scripts/ci_scripts/test_sdk.sh ./runSDK.sh

