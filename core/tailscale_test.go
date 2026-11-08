package core

import (
	"testing"

	"github.com/metacubex/mihomo/adapter"
	"github.com/metacubex/mihomo/adapter/outbound"
	"github.com/metacubex/mihomo/constant"
)

func TestTailscaleStatusRejectsMissingAndOtherProxies(t *testing.T) {
	withProbeProxies(t, "ordinary")
	for _, name := range []string{"missing", "ordinary"} {
		if _, err := handleTailscaleStatus(name); err == nil {
			t.Errorf("expected an error for %q", name)
		}
	}
}

func TestTailscaleOutboundIsFoundBehindTheClosingWrapper(t *testing.T) {
	previous := constant.Path.HomeDir()
	constant.SetHomeDir(t.TempDir())
	t.Cleanup(func() { constant.SetHomeDir(previous) })

	tailscale, err := outbound.NewTailscale(outbound.TailscaleOption{Name: "wrapped"})
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = tailscale.Close() })
	proxy := adapter.NewProxy(outbound.NewAutoCloseProxyAdapter(tailscale))

	found, ok := tailscaleOutbound(proxy)

	if !ok || found != tailscale {
		t.Fatalf("tailscaleOutbound = %v, %t, want the wrapped outbound", found, ok)
	}
}
