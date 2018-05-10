SITE=past.justatheory.com
BUCKET=${SITE}
BUILD_DIR=html
CLOUDFRONT_DISTID=EQQ9GCLH4A2YG

.DEFAULT_GOAL := default

${BUILD_DIR}:
	./bin/blosxom
	cp -rf static/* ${BUILD_DIR}

default: ${BUILD_DIR}

deploy: 
	aws s3 sync --acl public-read --sse --delete ${BUILD_DIR} s3://${BUCKET}
	aws configure set preview.cloudfront true
	aws cloudfront create-invalidation --distribution-id ${CLOUDFRONT_DISTID} --paths '/*'
