PATH := bin:vendor/bin:$(PATH)

deploy:
	serverless deploy

dashboard:
	bref dashboard
