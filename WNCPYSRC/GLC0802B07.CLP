/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       GLC0802B  DAILY EVENTS BY CURRENCY                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/*       Last Amend No. DUG503             Date 08Feb18              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       DUG503 - Events by Value Date Reporting                     */
/*                DUG431 - Amendments to 'Events by Value Date'      */
/*                Report                                             */
/*                DUG405 - Events by value date.                     */
/*                Upgrade of feature S20039 from ABS2.03 to DBA4.01. */
/*                                                                   */
/*********************************************************************/
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('DUG503')
             CHGVAR     VAR(&DUG503) VALUE('N')
/**  Check if Enhancement is installed */
 
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(DO)
                CHGVAR     VAR(&DUG503) VALUE('Y')
             ENDDO
 
/**/
             IF         COND(&DUG503 *EQ 'Y') THEN(DO)
 
/* Clear Customer Exchanges Extract File */
                CLRPFM     FILE(GLCXXFPP)
                CLRPFM     FILE(GLCXXZPP)
/* Clear Journal Entries Extract File */
                CLRPFM     FILE(GLJEXFPP)
                CLRPFM     FILE(GLJEXZPP)
 
/* Customer Exchanges Events Extract */
                OVRDBF     FILE(CUSEXCE) TOFILE(*LIBL/CUSEXCE_BK)
                CALL       PGM(GLD010) PARM('COB' '       ')
                DLTOVR     FILE(CUSEXCE)
 
/* Journal Entries Events Extract  */
                CALL       PGM(GLD020) PARM('COB' '       ')
 
 
/*  CALL MODIFIED VERSION OF GL0550 (CALLED GLD055) - CONSOLIDATED */
/*  -------------------------------------------------------------- */
/*                                                                 */
/* With override for DL events */
             CHGJOB     SWS(XXX0XXXX)
             OVRDBF     FILE(DLEVNIL2) TOFILE(DLEVNIL3)
/*  Call Consolidated version of value date report */
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
                          THEN(CALL PGM(GLD055) PARM(&TYPE &RSEQ))
             DLTOVR     FILE(DLEVNIL2)
 
/* With override for SE events */
             CHGJOB     SWS(XXX1XXXX)
             OVRDBF     FILE(DLEVNIL2) TOFILE(DLEVNIL4)
/*  Call Consolidated version of value date report */
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
                          THEN(CALL PGM(GLD055) PARM(&TYPE &RSEQ))
             DLTOVR     FILE(DLEVNIL2)
 
             ENDDO
 
