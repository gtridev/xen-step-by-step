#!/bin/bash

#xe vm-install template="Ubuntu Lucid Lynx 10.04 (64-bit)" new-name-label="Test VM" sr-uuid=828ee6d7-8f6d-aa65-e863-3c7edf956012
xe vm-param-set uuid=064e93e9-650a-ce65-9db5-6accf9475935 memory-static-max=1073741824
xe vm-param-set uuid=064e93e9-650a-ce65-9db5-6accf9475935 memory-dynamic-max=1073741824
xe vm-param-set uuid=064e93e9-650a-ce65-9db5-6accf9475935 memory-dynamic-min=524288000
xe vm-param-set uuid=064e93e9-650a-ce65-9db5-6accf9475935 memory-static-min=524288000
xe vm-memory-target-set uuid=064e93e9-650a-ce65-9db5-6accf9475935 target=1073741824
xe vm-param-set uuid=064e93e9-650a-ce65-9db5-6accf9475935 other-config:install-repository=http://np.archive.ubuntu.com/ubuntu/
xe vif-create vm-uuid=064e93e9-650a-ce65-9db5-6accf9475935 network-uuid=6827e6bd-319f-6c05-2f4b-c19f687c0362 mac=random device=0
xe vm-start uuid=064e93e9-650a-ce65-9db5-6accf9475935
