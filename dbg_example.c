/*
 * This is just a trivial demo for the dbg api, see the main function in dbg.c
 * for a better example.
 */

#include "dbg.h"

#define filename "foo.bar"

long length = 7;

int
main(void)
{

    /*
     * We suggest you use getopt(3) and strtol(3) (cast to an int)
     * to convert -v verbosity_level on the command line.
     */
    msg("NOTE: Setting verbosity_level to DBG_MED: %d", DBG_MED);
    verbosity_level = DBG_MED; /* DBG_MED == (3) */

    /*
     * This will print:
     *
     *	    Warning: main: elephant is sky-blue pink
     *
     * with newlines as described.
     */
    msg("NOTE: The next line should say: \"Warning: %s: %s", __func__, "elephant is sky-blue pink\"");
    warn(__func__, "elephant is sky-blue pink\n");

    /* this will not print anything as verbosity_level 3 (DBG_MED) < 5 (DBG_HIGH): */
    dbg(DBG_HIGH, "starting critical section");

    /*
     * Because verbosity_level == 3 (DBG_MED) and filename is "foo.bar" and
     * length == 7 this will print (with newlines added as described):
     *
     *	    debug[3]: file: foo.bar has length: 7
     */
    msg("NOTE: The next line should read: \"debug[3]: file: %s has length: %ld\"", filename, length);
    dbg(DBG_MED, "file: %s has length: %ld\n", filename, length);

    /*
     * If EPERM == 1 then this will print:
     *
     *	    ERROR[2]: main: test: errno[1]: Operation not permitted
     *
     * with newlines as discussed and then exit 2.
     */
    errno = EPERM;
    msg("NOTE: The next line should read: \"ERROR[2]: main: test: errno[%d]: %s\"", errno, strerror(errno));
    errp(2, __func__, "test");

    return 2; /* this return is never reached */
}
