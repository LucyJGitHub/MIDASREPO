/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       GLC0802B  DAILY EVENTS BY CURRENCY                          */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. DUG503 *CREATE     Date 08Feb18              */
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
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*DUG503*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*DUG503*/
             CHGVAR     VAR(&SAR) VALUE('DUG503')                                         /*DUG503*/
             CHGVAR     VAR(&DUG503) VALUE('N')                                           /*DUG503*/
/**  Check if Enhancement is installed */                                                 /*DUG503*/

             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*DUG503*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*DUG503*/
                CHGVAR     VAR(&DUG503) VALUE('Y')                                        /*DUG503*/
             ENDDO                                                                        /*DUG503*/

/**/
             IF         COND(&DUG503 *EQ 'Y') THEN(DO)                                    /*DUG503*/

/* Clear Customer Exchanges Extract File */
                CLRPFM     FILE(GLCXXFPP)                                                 /*DUG503*/
                CLRPFM     FILE(GLCXXZPP)                                                 /*DUG503*/
/* Clear Journal Entries Extract File */
                CLRPFM     FILE(GLJEXFPP)                                                 /*DUG503*/
                CLRPFM     FILE(GLJEXZPP)                                                 /*DUG503*/

/* Customer Exchanges Events Extract */
                OVRDBF     FILE(CUSEXCE) TOFILE(*LIBL/CUSEXCE_BK)                         /*DUG503*/
                CALL       PGM(GLD010) PARM('COB' '       ')                              /*DUG503*/
                DLTOVR     FILE(CUSEXCE)                                                  /*DUG503*/

/* Journal Entries Events Extract  */
                CALL       PGM(GLD020) PARM('COB' '       ')                              /*DUG503*/


/*  CALL MODIFIED VERSION OF GL0550 (CALLED GLD055) - CONSOLIDATED */
/*  -------------------------------------------------------------- */
/*                                                                 */
/* With override for DL events */
             CHGJOB     SWS(XXX0XXXX)                                                     /*DUG503*/
             OVRDBF     FILE(DLEVNIL2) TOFILE(DLEVNIL3)                                   /*DUG503*/
/*  Call Consolidated version of value date report */
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
                          THEN(CALL PGM(GLD055) PARM(&TYPE &RSEQ))                        /*DUG503*/ 
             DLTOVR     FILE(DLEVNIL2)                                                    /*DUG503*/

/* With override for SE events */
             CHGJOB     SWS(XXX1XXXX)                                                     /*DUG503*/
             OVRDBF     FILE(DLEVNIL2) TOFILE(DLEVNIL4)                                   /*DUG503*/ 
/*  Call Consolidated version of value date report */
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
                          THEN(CALL PGM(GLD055) PARM(&TYPE &RSEQ))                        /*DUG503*/
             DLTOVR     FILE(DLEVNIL2)                                                    /*DUG503*/

             ENDDO                                                                        /*DUG503*/

