/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE EUCLID Backlog Reports')                     */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module               */
/*                                                                  */
/*         SEC1203 - EUCLID BACKLOG REPORTS                         */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01502             DATE 08JUL94              */
/*       PREV AMEND NO. S01117             DATE 10JAN91              */
/*                      E16870             DATE 08/03/89             */
/*                      S01179             DATE 16/09/88             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01502 - BLI Telekurs Processing.  Recompiled due to        */
/*                change in length of SESTAT, 133 long.              */
/*       S01117 - MULTIBRANCHING                                     */
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                     */
/*       S01179 -  RELEASE                                        */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM       PARM(&MSG2 &MSG3)                             * *S01117*/
             PGM       PARM(&MSG2 &MSG3 &RSEQ)                        /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/*    THE RESTART PROCESSING IS GEARED AROUND THE VALUE HELD IN     */
/*    POSITION 51 OF SESTAT - AS FOLLOWS :                          */
/*                                                                  */
/*    0 - NO ERROR IN LAST RUN OF WHOLE SUITE                       */
/*    1 - ERROR OCCURED DURING LAST TRANSMISSION, SO RECOVER        */
/*        SECURITY COPY OF S/ECTLX & TRY AGAIN                      */
/*    2 - ERROR OCCURED DURING LAST REFORMATTING, SO RESTART THERE  */
/*    3 - ERROR OCCURED DURING LAST REPORTING, SO RESTART THERE     */
/*                                                                  */
/**/
             DCLF       FILE(EUCLIDWAIT)
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(SESTAT)                       ********  *S01179*/
/*           DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(256)        *S01179E16870*/
/************DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(128)*/    /*E16870 S01502*/
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)             /*S01502*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
/**/
/* S01179                                                              *S01179*/
/*********   RCVDTAARA  DTAARA(SESTAT)                      *********  *S01179*/
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)                /*S01179*/
/**/
/*   IF NO REPORTS REQUESTED, RESET DATA AREA & END PROGRAM         */
/**/
             IF         COND(%SST(&SESTAT 52 1) = ' ') THEN(DO)
                CHGDTAARA    DTAARA(SESTAT (51 1)) VALUE('0')
                GOTO       CMDLBL(ENDPGM)
             ENDDO
AGAIN:
/**/
/*    CALL BACKLOG PROMPT                                           */
/**/
             CALL       PGM(SE1250)
/**/
/*   CHECK IF ERROR IN SE1250                                        */
/**/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(+
                GOTO       CMDLBL(ENDPGM))
/**/
/*    SEE IF CMD/7 TAKEN IN SE1250, IF RESET FLAG & END PROGRAM      */
/**/
             IF         COND(%SWITCH(0000XXXX)) THEN(DO)
                CHGDTAARA    DTAARA(SESTAT (51 1)) VALUE('0')
                GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/*    SET OVERRIDE FOR SE1260                                       */
/**/
             IF         COND(%SWITCH(1XXXXXXX)) THEN(OVRDBF +
                          FILE(EBKLG) TOFILE(EBKL1))
             IF         COND(%SWITCH(X1XXXXXX)) THEN(OVRDBF +
                          FILE(EBKLG) TOFILE(EBKL2))
             IF         COND(%SWITCH(XX1XXXXX)) THEN(OVRDBF +
                          FILE(EBKLG) TOFILE(EBKL3))
             IF         COND(%SWITCH(XXX1XXXX)) THEN(OVRDBF +
                          FILE(EBKLG) TOFILE(EBKL4))
/**/
/*     SEND MESSAGE                                                  */
/**/
             SNDF       RCDFMT(EUCLIDF1)
             CHGVAR     VAR(&MSG1) VALUE(&MSG2)
             CHGVAR     VAR(&MSG2) VALUE(&MSG3)
             CHGVAR     VAR(&MSG3) VALUE('EUCLID Backlog Report +
                        Production')
             SNDF       RCDFMT(EUCLIDF2)
/**/
/*    CALL BACKLOG REPORT PROGRAM                                   */
/**/
/************CALL       PGM(SE1260)                                  * *S01117*/
             CALL       PGM(SE1260) PARM(&RSEQ)                       /*S01117*/
             DLTOVR     *ALL
/**/
/*    IF NO ERROR, GOTO TOP OF PROGRAM & PROMPT AGAIN                */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(+
                GOTO       CMDLBL(AGAIN))
/**/
/*ENDPGM:*****ENDPGM                                                 * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
