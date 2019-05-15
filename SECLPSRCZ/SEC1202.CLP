/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE EUCLID Reformat Backlog File')               */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module               */
/*                                                                  */
/*         SEC1202 - EUCLID BACKLOG FILE PROCESSING                 */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01502             Date 08Jul94              */
/*                      S01117             Date 10Jan91              */
/*                      E16870             DATE 08/03/89             */
/*                      S01179             DATE 16/09/88             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01502 - BLI Telekurs Processing.  Recompiled due to        */
/*                change in length of SESTAT, 133 long.              */
/*       S01117 - MULTIBRANCHING                                     */
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                     */
/*       S01179 -  RELEASE                                        */
/*                                                                   */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM       PARM(&MSG2 &MSG3)                             * *S01117*/
             PGM       PARM(&MSG2 &MSG3 &RSEQ)                        /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
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
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(SESTAT)                       ********  *S01179*/
/*           DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(256)        *S01179E16870*/
/************DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(128)*/    /*E16870 S01502*/
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)             /*S01502*/
             DCLF       FILE(EUCLIDWAIT)
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
/**/
/* S01179                                                              *S01179*/
/*********   RCVDTAARA  DTAARA(SESTAT)                      *********  *S01179*/
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)                /*S01179*/
/**/
/*    IF FLAG = '3', NO NEED TO RERUN THIS PROGRAM                 */
/**/
             IF         COND(%SST(&SESTAT 51 1) = '3') THEN( +
                GOTO       CMDLBL(ENDPGM))
/**/
/*    IF BACKLOG FILE NOT REQUESTED FOR TRANSMISSION SESSION, NO   */
/*    PROCESSING REQUIRED                                          */
/**/
             IF         COND(%SST(&SESTAT 52 1) = ' ') THEN( +
                GOTO       CMDLBL(ENDPGM))
/**/
/*     CLEAR BACKLOG FILES                                           */
/**/
             CLRPFM     FILE(EBKLGHB)
             CLRPFM     FILE(EBKLGDB)
             CLRPFM     FILE(EBKLGTB)
             CLRPFM     FILE(EAUTOHA)
             CLRPFM     FILE(EAUTODA)
             CLRPFM     FILE(EAUTOTA)
             CLRPFM     FILE(EBSETSS)
             CLRPFM     FILE(EBSETST)
/**/
/*     SEND MESSAGE                                                  */
/**/
             SNDF       RCDFMT(EUCLIDF1)
             CHGVAR     VAR(&MSG1) VALUE(&MSG2)
             CHGVAR     VAR(&MSG2) VALUE(&MSG3)
             CHGVAR     VAR(&MSG3) VALUE('EUCLID Backlog File +
                        Reformat')
             SNDF       RCDFMT(EUCLIDF2)
/**/
/*     REFORMAT EUCLID MESSAGES                                      */
/**/
             CALL       PGM(SE1220)
/**/
/*   CHECK IF ERROR FOUND IN SE1220, IF SO GOTO END                  */
/**/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ENDPGM))
/**/
/*     SEND MESSAGE                                                  */
/**/
             CHGVAR     VAR(&MSG1) VALUE(&MSG2)
             CHGVAR     VAR(&MSG2) VALUE(&MSG3)
             CHGVAR     VAR(&MSG3) VALUE('EUCLID Rejected +
                        Settlements Report')
             SNDF       RCDFMT(EUCLIDF2)
/**/
/*     AUTOMATIC SETTLEMENTS REPORT - REJECTED ITEMS                 */
/**/
             CHGJOB     SWS(XXX1XXXX)
/************CALL       PGM(SE1230)                                  * *S01117*/
             CALL       PGM(SE1230) PARM(&RSEQ)                       /*S01117*/
             CHGJOB     SWS(XXX0XXXX)
/**/
/*   CHECK IF ERROR FOUND IN SE1230, IF SO GOTO END                  */
/**/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ENDPGM))
/**/
/*   FIND OUT WHAT THE ICD OPTION IS FOR PROCESSING THE AUTOMATIC    */
/*   SETTLEMENTS RECEIVED FROM EUROCLEAR                             */
/**/
             IF         COND((%SST(&SESTAT 20 1) = '1') *OR +
                             (%SST(&SESTAT 20 1) = '3')) THEN(DO)
/**/
/*   OPTION 1                                                        */
/*OR OPTION 3 : PRODUCE REPORT OF ACCEPTED ITEMS                     */
/**/
/*     SEND MESSAGE                                                  */
/**/
             CHGVAR     VAR(&MSG1) VALUE(&MSG2)
             CHGVAR     VAR(&MSG2) VALUE(&MSG3)
             CHGVAR     VAR(&MSG3) VALUE('EUCLID Accepted +
                        Settlements Report')
             SNDF       RCDFMT(EUCLIDF2)
/**/
/*              AUTOMATIC SETTLEMENTS REPORT - ACCEPTED ITEMS        */
/**/
                CHGJOB     SWS(XXX0XXXX)
/***************CALL       PGM(SE1230)                               * *S01117*/
                CALL       PGM(SE1230) PARM(&RSEQ)                    /*S01117*/
                IF         COND(%SWITCH(XXXXXX00)) THEN(+
                   CHGDTAARA   DTAARA(SESTAT (51 1)) VALUE('3'))
             ENDDO
/**/
             IF         COND((%SST(&SESTAT 20 1) *EQ '2') *OR +
                             (%SST(&SESTAT 20 1) *EQ '3')) THEN(DO)
/**/
/*   OPTION 2                                                        */
/*OR OPTION 3 : MERGE INTO FILE OF SETTLEMENTS TO BE ACCEPTED        */
/**/
/*              CLEAR S/ENSET FILES                                 */
/**/
                CLRPFM     FILE(ENSETSS)
                CLRPFM     FILE(ENSETST)
/**/
/*              ALLOCATE S/ESETT EXCLUSIVELY BEFORE CALLING MERGE    */
/*              PROGRAM. IF ERROR, SEND MESSAGES                     */
/**/
                DLCOBJ     OBJ((ESETT *FILE *EXCL))
ALC:            ALCOBJ     OBJ((ESETT *FILE *EXCL)) WAIT(15)
                MONMSG     MSGID(CPF1002) EXEC(DO)
                   SNDPGMMSG  MSG('EUCLID Transmission Merge waiting +
                             for file') TOMSGQ(MOPERQ)
RPY:               SNDPGMMSG  MSG('EUCLID Transmission Merge waiting +
                         for file. Do you wish to re-try (Y or N) ?') +
                         TOPGMQ(*EXT) MSGTYPE(*INQ)
                   RCVMSG     MSGTYPE(*RPY) WAIT(*MAX) MSG(&RPY)
                   IF       COND(&RPY *EQ 'Y' *OR &RPY *EQ 'y') THEN( +
                          GOTO CMDLBL(ALC))
                   IF       COND(&RPY *EQ 'N' *OR &RPY *EQ 'n') THEN( +
                          GOTO CMDLBL(ENDPGM))
                   GOTO CMDLBL(RPY)
                ENDDO
/**/
/*     SEND MESSAGE                                                  */
/**/
             CHGVAR     VAR(&MSG1) VALUE(&MSG2)
             CHGVAR     VAR(&MSG2) VALUE(&MSG3)
             CHGVAR     VAR(&MSG3) VALUE('EUCLID +
                        Settlement File Merge')
             SNDF       RCDFMT(EUCLIDF2)
/**/
/*              EUCLID SETTLEMENTS MERGE                             */
/**/
                CALL       PGM(SE1240)
/**/
/*              CHECK IF ERROR FOUND IN SE1240                       */
/**/
                IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ENDPGM))
/**/
/*              RENAME S/ENSET TO S/ESETT                            */
/**/
                CLRPFM     FILE(ESETTSS)
                CPYF       FROMFILE(ENSETSS) TOFILE(ESETTSS) +
                             MBROPT(*ADD)  FMTOPT(*NOCHK)
                MONMSG     MSGID(CPF2817)
                CLRPFM     FILE(ESETTST)
                CPYF       FROMFILE(ENSETST) TOFILE(ESETTST) +
                             MBROPT(*ADD)  FMTOPT(*NOCHK)
                MONMSG     MSGID(CPF2817)
/**/
                DLCOBJ     OBJ((ESETT *FILE *EXCL))
/**/
                IF         COND(%SST(&SESTAT 20 1) = '2') THEN(+
                   CHGDTAARA   DTAARA(SESTAT (51 1)) VALUE('3'))
/**/
             ENDDO
/**/
             IF         COND(%SST(&SESTAT 20 1) = '3') THEN(DO)
/**/
/*   OPTION 3 : APPLY DIRECTLY TO DATABASE                           */
/**/
/*     SEND MESSAGE                                                  */
/**/
             CHGVAR     VAR(&MSG1) VALUE(&MSG2)
             CHGVAR     VAR(&MSG2) VALUE(&MSG3)
             CHGVAR     VAR(&MSG3) VALUE('EUCLID Automatic +
                        Settlement Acceptance')
             SNDF       RCDFMT(EUCLIDF2)
/**/
/*              APPLY EUCLID SETTLEMENTS TO DATABASE                 */
/**/
                OVRDBF     FILE(ESET1) TOFILE(ESETT) SHARE(*NO)
/***************CALL       PGM(SE1270)                               * *S01117*/
                CALL       PGM(SE1270) PARM(&RSEQ)                    /*S01117*/
                DLTOVR     FILE(ESET1)
                IF         COND(%SWITCH(XXXXXX00)) THEN(+
                   CHGDTAARA   DTAARA(SESTAT (51 1)) VALUE('3'))
             ENDDO
/**/
/*ENDPGM:*****ENDPGM                                                 * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
