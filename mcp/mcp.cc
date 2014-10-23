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
  vector<uint16_t> pat;
};

const uint16_t variable = 0;

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

  Local<String> s0(args[0]->ToString());
  int n = s0->Length();
  uint16_t s[n];
  s0->Write(s);

  Local<String> t0(args[1]->ToString());
  int m = t0->Length();
  uint16_t t[m];
  t0->Write(t);

  //for (int i=0;i<n;++i) cerr << s[i] << ' '; cerr << endl;
  //for (int i=0;i<m;++i) cerr << t[i] << ' '; cerr << endl;

  // init table
  X **table = new X*[n+1];
  for (int i=0; i<=n; ++i) {
    table[i] = new X[m+1];
    for (int j=0; j<=m; ++j) {
      table[i][j].len = 0;
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

  /*
  // debug
  for (int i=0; i<n; ++i) {
    for (int j=0; j<m; ++j) {
      cerr << table[i][j].len << ' ';
    }
    cerr << endl;
  }
  */

  // merging
  vector<vector<uint16_t> > ret0;
  uint16_t last = table[n][m].pat[0];
  ret0.push_back(vector<uint16_t>());
  ret0[0].push_back(table[n][m].pat[0]);

  for (int i=1, len = table[n][m].pat.size(); i<len; ++i) {
    if (last == variable) { // last was var
      if (table[n][m].pat[i] == variable) {
        // pass
      } else {
        // push char
        ret0.push_back(vector<uint16_t>(1, table[n][m].pat[i]));
      }
    } else {
      if (table[n][m].pat[i] == variable) {
        // push var
        ret0.push_back(vector<uint16_t>(1, variable));
      } else {
        // concat char
        ret0[ret0.size() - 1].push_back(table[n][m].pat[i]);
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
    int ren = ret0[i].size();
    uint16_t *us = new uint16_t[ren + 1];
    for (int j=0; j < ren; ++j) {
      us[j] = ret0[i][j];
    }
    us[ren] = 0;
    //for (int j=0; j < ren+1; ++j) cerr << ret0[i][j] << ' '; cerr << endl;
    ret->Set(i, String::New(us));
  }

  return scope.Close(ret);
}
