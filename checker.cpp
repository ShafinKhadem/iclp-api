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


signed main(signed argc, char const *argv[]) { cin.tie(0)->sync_with_stdio(0); cin.exceptions(cin.failbit); cout.precision(11), cout.setf(ios::fixed);
    assert(argc == 3);
    ifstream test(argv[1]);
    int n;
    test >> n;
    int ans = n*5;
    ifstream output(argv[2]);
    int out;
    output >> out;
    ASSERT(ans, ==, out);
}