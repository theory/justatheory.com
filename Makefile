SITE=past.justatheory.com
BUCKET=${SITE}
BUILD_DIR=html
CLOUDFRONT_DISTID=EQQ9GCLH4A2YG

.DEFAULT_GOAL := default

${BUILD_DIR}:
	cp -rf static ${BUILD_DIR}
	./bin/blosxom

default: ${BUILD_DIR}

deploy: ${BUILD_DIR}
	aws s3 sync --acl public-read --sse --delete ${BUILD_DIR} s3://${BUCKET}
	aws configure set preview.cloudfront true
	aws cloudfront create-invalidation --distribution-id ${CLOUDFRONT_DISTID} --paths '/*'

clean:
	rm -rf ${BUILD_DIR}

server: ${BUILD_DIR}
	./bin/pws
