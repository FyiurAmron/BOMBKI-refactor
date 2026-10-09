/* No-op stub for the crt Delay function.

   The unit-test builds link with --wrap=CRT_$$_DELAY$WORD, which
   redirects every call to the crt Delay(MS: Word) procedure to this
   symbol. FPC passes the Word parameter in a register (register
   calling convention), so ignoring it and returning immediately is
   safe: no stack cleanup is owed and the callee-saved registers are
   left untouched. This makes the per-round Delay(2000) in WALKA
   near-instant, so the Pascal unit tests run in milliseconds instead
   of minutes. Every other crt call (TextColor, ClrScr, ...) keeps
   using the original crt unit unchanged. */
void __wrap_CRT_$$_DELAY$WORD(void)
{
}
