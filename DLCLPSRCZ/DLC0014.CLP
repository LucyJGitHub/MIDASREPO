/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Initialisation program for CCM003')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Data Module                                 */
/*                                                                   */
/*       DLC0014 - Set up CCM003 switchable feature                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CCM003  *CREATE    Date 07Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCM003 - Midas/City Dealer cashflow interface.              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRE)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&FOLD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
/**/
/* Mode 1 - First call */
/**/
             IF         COND(&PMODE *EQ '1') THEN(DO)
 
/*    Get system prefix                                              */
                RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
                CHGVAR     VAR(&FOLD) VALUE('TSM' *TCAT &PRE)
 
/*    Create Folder TSMxx - If already created then continue processing */
                CRTFLR     FLR(&FOLD) TEXT('Midas/City Dealer ETVS PC +
                             File') AUT(*CHANGE)
                MONMSG     MSGID(CPF8A85 CPF8A18)
 
/*    Create data area LDA                                           */
                CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
                MONMSG     MSGID(CPF1023)
 
/*    Start commitment control                                       */
 
                ENDCMTCTL
                MONMSG     MSGID(CPF0000)
 
                STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
 
                CALL       PGM(DL0014) PARM(' ')
 
                CALL       PGM(DL0012) PARM('TAKEON' ' ')
 
             ENDDO
 
/**/
/* Mode 2 - Second call */
/**/
             IF         COND(&PMODE *EQ '2') THEN(DO)
 
/*    Get system prefix                                              */
                RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
                CHGVAR     VAR(&FOLD) VALUE('TSM' *TCAT &PRE)
 
/*    Create Folder TSMxx - If already created then continue processing */
                CRTFLR     FLR(&FOLD) TEXT('Midas/City Dealer ETVS PC +
                             File') AUT(*CHANGE)
                MONMSG     MSGID(CPF8A85 CPF8A18)
 
/*    Create data area LDA                                           */
                CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
                MONMSG     MSGID(CPF1023)
 
/*    Start commitment control                                       */
 
                ENDCMTCTL
                MONMSG     MSGID(CPF0000)
 
                STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
 
                CALL       PGM(DL0014) PARM(' ')
 
                CALL       PGM(DL0012) PARM('TAKEON' ' ')
 
             ENDDO
 
/**/
/* Mode 3 - Deletion */
/**/
             IF         COND(&PMODE *EQ '3') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal Processing */
 
 ABNOR:
             SNDPGMMSG  TOMSGQ(MOPERQ) MSG('Program DLC0014 +
                          ended abnormally')
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
