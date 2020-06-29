/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       GLC0802B  DAILY EVENTS BY CURRENCY                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/*       Last Amend No. DUG503             Date 08Feb18              */
/*       Prev Amend No. xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       DUG503 - Events by Value Date Reporting                     */
/*                DUG405 - Events by value date.                     */
/*                Upgrade of feature S20039 from ABS2.03 to DBA4.01. */
/*                                                                   */
/*********************************************************************/
             IF         COND(&DUG503 *EQ 'Y') THEN(DO)
/*  CALL MODIFIED VERSION OF GL0551 (CALLED GLD056) - BY BRANCH    */
/*  -----------------------------------------------------------    */
/*                                                                 */
/* With override for DL events */
             CHGJOB     SWS(XXX0XXXX)
             OVRDBF     FILE(DLEVNTLI) TOFILE(DLEVNTLJ)
/*  Call By Branch version of value date report */
             IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(GLD056) +
                          PARM(&TYPE &RSEQ &RENT))
             DLTOVR     FILE(DLEVNTLI)
 
/* With override for SE events */
             CHGJOB     SWS(XXX1XXXX)
             OVRDBF     FILE(DLEVNTLI) TOFILE(DLEVNTLK)
/*  Call By Branch version of value date report */
             IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(GLD056) +
                          PARM(&TYPE &RSEQ &RENT))
             DLTOVR     FILE(DLEVNTLI)
 
             ENDDO
