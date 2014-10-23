#include <node.h>
#include <v8.h>
#include "mcp.h"
using namespace v8;
void init(Handle<Object> exports) {
  exports->Set(String::NewSymbol("mcp"),
      FunctionTemplate::New(Mcp)->GetFunction());
}
NODE_MODULE(mcp, init)
