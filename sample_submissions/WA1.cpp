//#undef DEBUG
#include <bits/stdc++.h>
using namespace std;
using ll = long long;
const ll llinf = (1ll<<61)-1;
#define sz(a) int(a.size())
#define all(x) begin(x), end(x)
#ifdef DEBUG
const int DEBUG_END = 26;
#include <debug.h>
#else
#define bug(args...) void()
#define cbug(args...) void()
#endif
#define ASSERT(a, o, b, args...) (((a)o(b)) ? void() : (bug(a, b, ##args), assert((a)o(b))))
#define fi first
#define se second
int TC = 1, CN;
const int inf = 1000000007;


signed main() { cin.tie(0)->sync_with_stdio(0); cin.exceptions(cin.failbit); cout.precision(11), cout.setf(ios::fixed);
    //cin >> TC;// inputAll + resetAll -> solution
    auto kase = [&]()->void {
        int n;
        cin >> n;
        if (n != 5) cout << n*5 << '\n';
    };
    while (CN++!=TC) kase();
}
