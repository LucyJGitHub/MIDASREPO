/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM PARENT LIMIT/EXPOSURE/AVAIL REPRT')          */
/********************************************************************/
/*                                                                  */
/*       Midas     EXPOSURE MANAGEMENT MODULE                   */
/*                                                                  */
/*       EMC0803 - PARENT LIMIT/EXPOSURE/AVAILABILITY REPORT        */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No.  087568          DATE  26SEP95              */
/*       Prev Amend No.  LN0081          DATE  02MAY90              */
/*                       S01117          DATE  31/10/89             */
/*                                                                  */
/********************************************************************/
/*       087568 - ACCESS TO ZSFILE PRODUCES AN VERY LONG JOBLOG     */
/*       LN0081 - RCF PARMS INCORRECT                               */
/*       S01117 - RELEASE TEN MULTIBRANCHING                        */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*           PGM                                         */ /*S01117*/
/*        PGM PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)/*S01117*/  /*LN0081*/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)              /*LN0081*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                /*S01117*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)             /*S01117*/
/*           DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)    */          /*LN0081*/
/*           DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)    */          /*LN0081*/
/*           DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)     */          /*S01117*/
/*/COPY WNCPYSRC,EMC0803001                                          */
/**/
/*           DCLF       FILE(EM0610FM)                   */ /*S01117*/
/**/
 
             SNDPGMMSG  MSG('Parent Exposure/Limit/Availability +
                        Report') TOMSGQ(MRUNQ)
/**/
/*           CHGVAR &IN92 '1'                            */ /*S01117*/
/**/
/*       A:  SNDRCVF RCDFMT(EM0610FM)                    */ /*S01117*/
/**/
/*           IF &IN07 RETURN                             */ /*S01117*/
/*           ELSE DO                                     */ /*S01117*/
/*               IF (&FULLRE *EQ E) CHGJOB SWS(1XXXXXXX)       */ /*S01117*/
/*               ELSE IF (&FULLRE *EQ F) CHGJOB SWS(0XXXXXXX)  */ /*S01117*/
/**/
/*               ELSE DO                                       */ /*S01117*/
/*                  CHGVAR &IN92 '0'                           */  /*S01117*/
/*                  CHGVAR &IN93 '1'                           */  /*S01117*/
/*                  GOTO A                                     */  /*S01117*/
/*               ENDDO                                         */  /*S01117*/
/**/
/*           ENDDO                                             */  /*S01117*/
/**/
/**/
             IF         COND(%SST(&RPARM 1 1) *EQ 'E') THEN(CHGJOB +
                          SWS(1XXXXXXX))                             /*S01117*/
             IF         COND(%SST(&RPARM 1 1) *EQ 'F') THEN(CHGJOB +
                          SWS(0XXXXXXX))                            /*S01117*/
/*           CALL       PGM(EM0610)                      */ /*S01117*/
             OVRDBF     FILE(MAARCDPD) SEQONLY(*NO)         /*087568*/
/*/COPY WNCPYSRC,EMC0803002                                          */
             CALL       PGM(EM0610) PARM(&RSEQ &RENT)      /*S01117*/
/*/COPY WNCPYSRC,EMC0803003                                          */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
           ENDPGM
