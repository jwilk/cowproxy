# encoding=UTF-8

# Copyright © 2017 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

try:
    from mitmproxy.http import Response as HTTPResponse  # mitmproxy >= 7.0
except ImportError:
    try:
        from mitmproxy.http import HTTPResponse  # mitmproxy >= 1.0
    except ImportError:
        from mitmproxy.models import HTTPResponse

cow = r'''
^__^
(oo)\_______
(__)\       )\/\
    ||----w |
    ||     ||
'''.lstrip('\n')

def request(flow):
    flow.response = HTTPResponse.make(
        200,
        cow,
        {'Content-Type': 'text/plain'}
    )

# vim:ts=4 sts=4 sw=4 et
