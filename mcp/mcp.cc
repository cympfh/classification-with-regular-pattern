#include <node.h>
#include <v8.h>
#include "mcp.h"
#include <string>
#include <vector>
#include <iostream>

using namespace std;
using namespace v8;

struct X {
  int len;
  vector<string> pat;
};

const string variable = "";

Handle<Value> Mcp(const Arguments& args) {
  HandleScope scope;
  // type check of args
  if ( !args[0]->IsString()
      || !args[1]->IsString()) {
    Local<String> msg = String::New("mcp :: (String, String) -> [String]");
    ThrowException(Exception::TypeError(msg));
    return scope.Close(Undefined());
  }

  /*
   * Node.js -> C++
   */

  vector<string> s, t;

  char *s0 = *String::Utf8Value(args[0]->ToString());
  char cc[2];
  for (int i=0; s0[i]; ++i) {
    cc[0] = s0[i];
    cout << "s0 of " << i << "is " << s0[i] << endl;
    s.push_back(std::string(1, cc[0]));
  }

  char *t0 = *String::Utf8Value(args[1]->ToString());
  for (int i=0; t0[i]; ++i) {
    t.push_back(std::string(1, t0[i]));
  }

  cout << s.size() << endl;
  for (int i=0; i<s.size(); ++i) cout << s[i] << ' '; cout << endl;
  cout << t.size() << endl;
  for (int i=0; i<t.size(); ++i) cout << t[i] << ' '; cout << endl;

  // init table
  int n = s.size();
  int m = t.size();

  X **table = new X*[n+1];
  for (int i=0; i<n; ++i) {
    table[i] = new X[m+1];
    for (int j=0; j<m; ++j) {
      table[i][j].len = 0;
      cout << "table " << i << ", " << j << table[i][j].len << endl;
      if (i != 0 || j != 0) table[i][j].pat.push_back(variable);
    }
  }

  // DP
  for (int i=0; i<n; ++i) {
    for (int j=0; j<m; ++j) {
      // update table[i+1][j+1]
      int l0 = s[i] == t[j] ? table[i][j].len + 1 : 0;
      int l1 = table[i+1][j].len;
      int l2 = table[i][j+1].len;

      if (l0 > l1 && l0 > l2) {
          table[i+1][j+1].len = l0;
          table[i+1][j+1].pat = table[i][j].pat;
          table[i+1][j+1].pat.push_back(s[i]);
      } else if (l1 > l0 && l1 > l2) {
          table[i+1][j+1].len = l1;
          table[i+1][j+1].pat = table[i+1][j].pat;
          table[i+1][j+1].pat.push_back(variable);
      } else {
          table[i+1][j+1].len = l2;
          table[i+1][j+1].pat = table[i][j+1].pat;
          table[i+1][j+1].pat.push_back(variable);
      }
    }
  }

  cout << "a" << endl;
  cout << table[0][0].len << endl;
  cout << "b" << endl;

  // merging
  vector<string> ret0;
  string last = table[n][m].pat[0];
  ret0.push_back(table[n][m].pat[0]);

  for (int i=1, len = table[n][m].pat.size(); i<len; ++i) {
    if (last == "") { // last was var
      if (table[n][m].pat[i] == "") {
        // pass
      } else {
        ret0.push_back(table[n][m].pat[i]);
      }
    } else {
      if (table[n][m].pat[i] == "") {
        ret0.push_back(variable);
      } else {
        ret0[ret0.size() - 1] = ret0[ret0.size() - 1] + table[n][m].pat[i];
      }
    }
    last = table[n][m].pat[i];
  }

  /*
   * C++ -> Node.js
   */
  int len = ret0.size();
  Local<Array> ret = Array::New(len);
  for (int i=0; i<len; ++i) {
    ret->Set(i, String::New(ret0[i].c_str()));
  }

  return scope.Close(ret);
}
