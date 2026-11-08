package core

import (
	"context"
	"fmt"
	"time"

	"github.com/metacubex/mihomo/adapter/outbound"
	"github.com/metacubex/mihomo/constant"
)

func handleTailscaleStatus(name string) (*outbound.TailscaleStatus, error) {
	proxy := lookupProxy(name)
	if proxy == nil {
		return nil, fmt.Errorf("proxy %q not found", name)
	}
	tailscale, ok := tailscaleOutbound(proxy)
	if !ok {
		return nil, fmt.Errorf("proxy %q is not a Tailscale outbound", name)
	}
	ctx, cancel := context.WithTimeout(context.Background(), 35*time.Second)
	defer cancel()
	return tailscale.StartAndStatus(ctx)
}

// Parsed outbounds sit behind the adapter's closing wrapper, so the concrete
// type is reached through it rather than asserted on the wrapper itself.
func tailscaleOutbound(proxy constant.Proxy) (*outbound.Tailscale, bool) {
	adapter := proxy.Adapter()
	if unwrapper, ok := adapter.(outbound.ProxyAdapterUnwrapper); ok {
		adapter = unwrapper.UnwrapProxyAdapter()
	}
	tailscale, ok := adapter.(*outbound.Tailscale)
	return tailscale, ok
}
