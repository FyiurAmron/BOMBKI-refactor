/* Deterministic PRNG for the test builds.
 *
 * The game seeds Random from the clock (BOMBKI.PAS calls Randomize at
 * start-up), so every run draws a different sequence. That makes any
 * scenario whose outcome depends on a roll intermittent: it passes on
 * one run and times out on the next, because the executable starts a
 * fraction of a second later each time.
 *
 * These builds link with --wrap on the four System PRNG entry points,
 * which redirects every call to the symbols below. The originals stay
 * linked but unreferenced, so nothing else about the runtime changes -
 * the same mechanism the Delay stub already uses.
 *
 * The generator is xorshift64*: small, no initialisation needed, and
 * it passes BigCrush. A test wants a reproducible sequence rather
 * than a statistically excellent one, and the game's own draws are
 * uniform modulo a small bound, which this reproduces. State lives in
 * a file-scope variable so each call advances it; returning a constant
 * would make every draw identical and collapse exactly the branches
 * these tests need to reach.
 *
 * The seed comes from BOMBKI_SEED, so a scenario can pin the sequence
 * it depends on, and otherwise from a fixed default. Randomize ignores
 * the clock entirely: sampling the time when the executable happens to
 * run drifts by however long the build and start-up took, so it is not
 * reproducible even in principle. */

#include <stdint.h>

/* The link is freestanding: the delay stub links the same way, and
   libc is not pulled in, so getenv and strtoull cannot be called.
   FPC's own accessor is already in the binary (see nm on a linked
   build) and reaches the process environment, which is exactly what
   is needed here. The Pascal signature is
   function FpGetEnv(const Name: PChar): PChar; and its mangled
   System name is spelled out below. It is an ordinary runtime symbol, not one
   of the wrapped ones, so it keeps its own name. */
char *SYSTEM_$$_FPGETENV$PCHAR$$PCHAR(char *name);

#define BOMBKI_DEFAULT_SEED UINT64_C(0x9E3779B97F4A7C15)

static uint64_t bombki_state = BOMBKI_DEFAULT_SEED;

/* Parse decimal or 0x-prefixed hexadecimal; 0 when empty or
   unparsable, which the caller turns back into the default. A seed is
   a handful of characters, so a loop is cheaper than a libc call the
   freestanding link cannot resolve. */
static uint64_t parse_seed(const char *text)
{
    uint64_t value = 0;
    int base = 10;
    int digits = 0;

    if (text == 0)
        return 0;
    while (*text == ' ' || *text == '\t')
        text++;
    if (text[0] == '0' && (text[1] == 'x' || text[1] == 'X')) {
        base = 16;
        text += 2;
    }
    for (; *text != '\0'; text++) {
        unsigned digit;
        if (*text >= '0' && *text <= '9')
            digit = (unsigned)(*text - '0');
        else if (base == 16 && *text >= 'a' && *text <= 'f')
            digit = (unsigned)(*text - 'a') + 10u;
        else if (base == 16 && *text >= 'A' && *text <= 'F')
            digit = (unsigned)(*text - 'A') + 10u;
        else
            break;
        value = value * (uint64_t)base + digit;
        digits++;
    }
    return digits == 0 ? 0 : value;
}

/* Read the seed for this run. Called on every Randomize so a test can
   change BOMBKI_SEED between runs without rebuilding. */
static void apply_seed(void)
{
    uint64_t value = parse_seed(
        SYSTEM_$$_FPGETENV$PCHAR$$PCHAR("BOMBKI_SEED"));
    bombki_state = (value == 0) ? BOMBKI_DEFAULT_SEED : value;
}

/* Longint is 32-bit in FPC, so the result must land in [0, bound).
   The scaled product is reduced modulo the bound: returning the
   product's high word directly would hand back values far outside
   the range, and the game prints those straight into text (a
   monster drops "WYCIAGASZ -12798 MONET"), so a missing modulo
   shows up as nonsense output rather than as a crash. */
static uint32_t next_below(uint32_t bound)
{
    uint64_t x = bombki_state;
    x ^= x >> 12;
    x ^= x << 25;
    x ^= x >> 27;
    bombki_state = x;
    return (uint32_t)(((x * UINT64_C(2685821657736338717)) >> 32) % bound);
}

/* Randomize: fix the seed instead of sampling the clock. */
void __wrap_SYSTEM_$$_RANDOMIZE(void)
{
    apply_seed();
}

/* Random(LONGINT). Random(0) returns 0 without advancing, as FPC
   documents. */
long int __wrap_SYSTEM_$$_RANDOM$LONGINT$$LONGINT(long int bound)
{
    if (bound <= 0)
        return 0;
    return (long int)next_below((uint32_t)bound);
}

/* Random(Int64): the 64-bit overload, same scheme. */
long long __wrap_SYSTEM_$$_RANDOM$INT64$$INT64(long long bound)
{
    if (bound <= 0)
        return 0;
    return (long long)next_below((uint32_t)bound);
}

/* Random(Extended): the float overload. The game only calls Random
   with integer bounds, but the symbol must exist because the runtime
   references it and --wrap redirects those references here too. */
long double __wrap_SYSTEM_$$_RANDOM$$EXTENDED(long double bound)
{
    if (bound <= 0.0L)
        return 0.0L;
    return bound * (long double)next_below(0xFFFFFFFFu) / 4294967295.0L;
}
