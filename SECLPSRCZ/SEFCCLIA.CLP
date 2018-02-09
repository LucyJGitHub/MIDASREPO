/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Build TDFF63 based on STSECPO for Telekur')  */
/*********************************************************************/
/*                                                                   */
/*       Midas    - Telekurs Interface                               */
/*                                                                   */
/*       SEFCCLIA - SE Build TDFF63 based on STSECPO for Telekurs    */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSE067  *CREATE    Date 25Apr05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE067 - Telekurs Interface Changes                         */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&X) TYPE(*DEC) LEN(10)
             DCL        VAR(&SYSNAME) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)
             DCL        VAR(&TELK)   TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7) VALUE('*FIRST ')
             DCL        VAR(&SAR)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&DAYS) TYPE(*DEC) LEN(5 0)
 
             DCL        VAR(&PRTCD)  TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL        VAR(&POPTN)  TYPE(*CHAR) LEN(7) VALUE('*FIRST ')
             DCL        VAR(&PSARD)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PSCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CSE067) TYPE(*CHAR) LEN(1) VALUE('N')
 
             DCLF       FILE(SDBANKPD)
 
             MONMSG     MSGID(CPA0000 CPF0000 CPI0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ERROR))
 
             CHGVAR     VAR(&PRTCD) VALUE(' ')
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&PSARD) VALUE('CSE067')
 
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD +
                          &PSCSARD)
 
             IF         COND(&PRTCD *EQ ' ') THEN(CHGVAR +
                        VAR(&CSE067) VALUE('Y'))
 
             IF         COND(&PRTCD *NE ' ' *AND &PRTCD *NE '*NRF') +
                          THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
 
             IF         COND(&CSE067 *EQ 'N') THEN(GOTO CMDLBL(END))
 
             CHGJOB     RUNPTY(19) LOG(4 00 *MSG) LOGCLPGM(*YES) +
                          SWS(00000000)
             RTVNETA    SYSNAME(&SYSNAME)
             ADDLIBLE   LIB(TDFCLIICF) POSITION(*FIRST)
 
             OVRDBF     FILE(SDBANKPD) SHARE(*NO)
             RCVF
             CHGVAR     VAR(&DAYS) VALUE(&BJRDNB)
 
             CHGVAR     VAR(&TELK) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR)  VALUE('CSE009')
 
             CALL       PGM(AOSARDR0) PARM(&TELK &OPTN &SAR &SCSARD)
 
   DEBUT:
                ADDICFDEVE FILE(ICFFCLI) PGMDEV(PGMDEV) +
                           RMTLOCNAME(BSC5) CMNTYPE(*BSCEL) BLOCK(*IRS)
                MONMSG     MSGID(CPF7365) EXEC(DO)
                   RMVICFDEVE FILE(ICFFCLI) PGMDEV(PGMDEV)
                   GOTO       CMDLBL(DEBUT)
                ENDDO
/**/
/* NO INTERRUPT                                                      */
/* ANSWER LINE                                                       */
/* BSC                                                               */
/**/
                CHGCTLBSC  CTLD(BSC5) INLCNN(*DIAL)
                VRYCFG     CFGOBJ(LBSC5) CFGTYPE(*LIN) STATUS(*ON)
                DLYJOB     DLY(1)
                VRYCFG     CFGOBJ(BSC5) CFGTYPE(*CTL) STATUS(*ON)
                VRYCFG     CFGOBJ(BSC5) CFGTYPE(*DEV) STATUS(*ON)
/**/
/* COPIE DU FICHIER DE SELECTION DU CLIENT                           */
/**/
                IF         COND((&TELK *EQ '       ') *OR (&DAYS >= +
                             09978)) THEN(CHGJOB SWS(01000000))
                ELSE       CMD(CHGJOB SWS(10000000))
 
                CLRPFM     FILE(TDFF63)
                CALL       PGM(SEFPCLIA)
                CLRPFM     FILE(TDFF64)
                CLRPFM     FILE(TDFF65)
                CLRPFM     FILE(TDFF66)
/**/
/* CALL TRANSMSSION/RECEIVING PROGRAM                                */
/**/
                CALL       PGM(SEFPCLI)
/**/
/* BSC                                                               */
/**/
                VRYCFG     CFGOBJ(BSC5) CFGTYPE(*DEV) STATUS(*OFF)
                VRYCFG     CFGOBJ(BSC5) CFGTYPE(*CTL) STATUS(*OFF)
                VRYCFG     CFGOBJ(LBSC5) CFGTYPE(*LIN) STATUS(*OFF)
                RMVICFDEVE FILE(ICFFCLI) PGMDEV(PGMDEV)
/**/
/* GENERATION TITLE BULLETIN                                         */
/**/
             RTVMBRD    FILE(TDFF66) NBRCURRCD(&X)
                IF         COND(&X *GT 1) THEN(DO)
                   CHGVAR     VAR(&X) VALUE(&X - 1)
                   OVRPRTF    QSYSPRT PAGESIZE(*N 198) CPI(15) FONT(*CPI) +
                              CTLCHAR(*FCFC)
                   CPYF       FROMFILE(TDFF66) TOFILE(QSYSPRT) FROMRCD(2) +
                              TORCD(&X)
                   DLTOVR     QSYSPRT
                ENDDO
/**/
/* COPIE DU FICHIER RECU DE SERVITIA                                 */
/**/
             IF         COND((&TELK *EQ '       ') *OR (&DAYS >= +
                          09978)) THEN(DO)
             CPYF       FROMFILE(TDFF64) TOFILE(SETKURPD) +
                          MBROPT(*REPLACE) INCCHAR(*RCD 1 *EQ 8) +
                          FMTOPT(*NOCHK)
             ENDDO
             ELSE CMD(DO)
             CPYF       FROMFILE(TDFF64) TOFILE(TELEKUR2) +
                          MBROPT(*REPLACE) INCCHAR(*RCD 1 *EQ 8) +
                          FMTOPT(*NOCHK)
             ENDDO
/**/
/**  UPDATE MIDAS DTA AREA SESTAT TO INDICATE THAT TELEKUR2 FILE     */
/**  HAS BEEN UPDATED TO DISK.                                       */
/**/
                RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
                CHGVAR     VAR(%SST(&SESTAT 130 1)) VALUE('Y')
                CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
                GOTO END
/**/
 ERROR:      SNDPGMMSG  MSG('TELEKURS PRICES UPDATE ENDED ABNORMALLY') +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ QSYSOPR)
/**/
/*     BE SURE VARY OFF COMPLETE BEFORE END OF PROGRAM               */
/**/
 END:        VRYCFG     CFGOBJ(BSC5) CFGTYPE(*DEV) STATUS(*OFF)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             VRYCFG     CFGOBJ(BSC5) CFGTYPE(*CTL) STATUS(*OFF)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             VRYCFG     CFGOBJ(LBSC5) CFGTYPE(*LIN) STATUS(*OFF)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RMVICFDEVE FILE(ICFFCLI) PGMDEV(PGMDEV)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RMVLIBLE   LIB(TDFCLIICF)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')
             ENDPGM
