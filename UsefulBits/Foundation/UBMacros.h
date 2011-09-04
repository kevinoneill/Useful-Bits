  //  Copyright (c) 2011, Kevin O'Neill
  //  All rights reserved.
  //
  //  Redistribution and use in source and binary forms, with or without
  //  modification, are permitted provided that the following conditions are met:
  //
  //  * Redistributions of source code must retain the above copyright
  //   notice, this list of conditions and the following disclaimer.
  //
  //  * Redistributions in binary form must reproduce the above copyright
  //   notice, this list of conditions and the following disclaimer in the
  //   documentation and/or other materials provided with the distribution.
  //
  //  * Neither the name UsefulBits nor the names of its contributors may be used
  //   to endorse or promote products derived from this software without specific
  //   prior written permission.
  //
  //  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  //  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  //  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  //  DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
  //  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  //  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  //  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  //  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  //  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  //  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifdef DEBUG
#define IS_DEBUG   1
#define IS_RELEASE 0
#else
#define IS_DEBUG   0
#define IS_RELEASE 1
#endif

#define UBRELEASE_NIL(INSTANCE__)      { [INSTANCE__ release]; INSTANCE__ = nil; }
#define UBRELEASE_DEADBABE(INSTANCE__) { [INSTANCE__ release]; *((uint *) &INSTANCE__) = 0xDEADBABE; }

#if IS_DEBUG
#define UBRELEASE(INSTANCE__) UBRELEASE_DEADBABE(INSTANCE__)
#else
#define UBRELEASE(INSTANCE__) UBRELEASE_NIL(INSTANCE__)
#endif

#define UBSWAP_INSTANCE_RETAIN(DESTINATION__, SOURCE__) \
{                                                   \
  id old_value__ = DESTINATION__;                   \
  DESTINATION__ = [(SOURCE__) retain];              \
  [old_value__ release];                            \
}

#define UBSWAP_INSTANCE_COPY(DESTINATION__, SOURCE__) \
{                                                 \
  id old_value__ = DESTINATION__;                 \
  DESTINATION__ = [(SOURCE__) copy];              \
  [old_value__ release];                          \
}

#define CLAMP(VALUE__, MIN__, MAX__) \
MIN((MAX__), MAX((MIN__), (VALUE__)))
