/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MR Extract queries')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - MidasPlus Reporting module                          */
/*                                                                   */
/*       MRC0510 - Extract Queries                                   */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BUG13251           Date 08Feb07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      237298             Date 06Jan06              */
/*                      BUG10885           Date 17Mar06              */
/*                      CMR001  *CREATE    Date 07Sep04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG13251 - Component failure, library ACNCLIB not found.    */
/*       237298 - Component failure due to xxUPLIB which cannot be   */
/*                found by system. Use xxNCLIB for new structure.    */
/*       BUG10885 - MRC0510 00001 ended abnormally                   */
/*       CMR001 - MidasPlus Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2004')
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                 /*BUG13251*/
             DCL        VAR(&SVALK1) TYPE(*CHAR) LEN(20)                                /*BUG13251*/
             DCL        VAR(&SVAL1)  TYPE(*CHAR) LEN(200)                               /*BUG13251*/
             DCL        VAR(&SVALK2) TYPE(*CHAR) LEN(20)                                /*BUG13251*/
             DCL        VAR(&SVAL2) TYPE(*CHAR) LEN(200)                                /*BUG13251*/
             DCL        VAR(&SVALK3) TYPE(*CHAR) LEN(20)                                /*BUG13251*/
             DCL        VAR(&SVAL3) TYPE(*CHAR) LEN(200)                                /*BUG13251*/
             DCL        VAR(&SVALK4) TYPE(*CHAR) LEN(20)                                /*BUG13251*/
             DCL        VAR(&SVAL4) TYPE(*CHAR) LEN(200)                                /*BUG13251*/
             DCL        VAR(&SVALK5) TYPE(*CHAR) LEN(20)                                /*BUG13251*/
             DCL        VAR(&SVAL5) TYPE(*CHAR) LEN(200)                                /*BUG13251*/
             DCL        VAR(&SVALK6) TYPE(*CHAR) LEN(20)                                /*BUG13251*/
             DCL        VAR(&SVAL6) TYPE(*CHAR) LEN(200)                                /*BUG13251*/
             DCL        VAR(&SVALK7) TYPE(*CHAR) LEN(20)                                /*BUG13251*/
             DCL        VAR(&SVAL7) TYPE(*CHAR) LEN(200)                                /*BUG13251*/
             DCL        VAR(&SVALK8) TYPE(*CHAR) LEN(20)                                /*BUG13251*/
             DCL        VAR(&SVAL8) TYPE(*CHAR) LEN(200)                                /*BUG13251*/
             DCL        VAR(&SVALK9) TYPE(*CHAR) LEN(20)                                /*BUG13251*/
             DCL        VAR(&SVAL9) TYPE(*CHAR) LEN(200)                                /*BUG13251*/
             DCL        VAR(&SVALK0) TYPE(*CHAR) LEN(20)                                /*BUG13251*/
             DCL        VAR(&SVAL10) TYPE(*CHAR) LEN(200)                               /*BUG13251*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                                 /*BUG13251*/
             DCLF       FILE(MRRPRMPD)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('MRC0510 - Extract Queries') TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
             CLRPFM     FILE(MRQRYRPD)
 
/*Library*/
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))                           /*BUG10885*/
             IF         COND(&RPLIB *EQ '          ') THEN(DO)
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIB)
/**********  CHGVAR     VAR(&RPLIB) VALUE(&LIB *CAT 'UPLIB')                              /*237298*/
/**********  CHGVAR     VAR(&RPLIB) VALUE(&LIB *CAT 'NCLIB') */              /*237298*/ /*BUG13251*/
                                                                                        /*BUG13251*/
/* Get Global System Prefix from GPSVALPD */                                            /*BUG13251*/
                                                                                        /*BUG13251*/
             CHGVAR     VAR(&SVALK1) VALUE('GlobalSystemPrefix')                        /*BUG13251*/
                                                                                        /*BUG13251*/
             CALL       PGM(GPAOSVALR0) PARM(&RTNCDE &SVALK1 &SVAL1 +
                          &SVALK2 &SVAL2 &SVALK3 &SVAL3 &SVALK4 +
                          &SVAL4 &SVALK5 &SVAL5 &SVALK6 &SVAL6 +
                          &SVALK7 &SVAL7 &SVALK8 &SVAL8 &SVALK9 +
                          &SVAL9 &SVALK0 &SVAL10)                                       /*BUG13251*/
                                                                                        /*BUG13251*/
/* If the 'GlobalSystemPrefix' system value is missing then end abnormally */           /*BUG13251*/
                                                                                        /*BUG13251*/
             IF         COND(%SST(&SVAL1 1 4) *EQ '*NRF') THEN(GOTO +
                          CMDLBL(ABNOR))                                                /*BUG13251*/
                                                                                        /*BUG13251*/
             CHGVAR     VAR(&PREFIX) VALUE(%SUBSTRING(&SVAL1 1 2))                      /*BUG13251*/
             CHGVAR     VAR(&RPLIB) VALUE('NC_' *CAT &PREFIX *CAT +
                          '_S00')                                                       /*BUG13251*/
                                                                                        /*BUG13251*/
             ENDDO
 
/*List of queries*/
             DSPOBJD    OBJ(&RPLIB/*ALL) OBJTYPE(*QRYDFN) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/MRQRY)
             MONMSG     MSGID(CPF2123) EXEC(GOTO CMDLBL(END))
 
             CALL       PGM(MR000510)
 
/*error*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                IF         COND(&JOBTYPE = '0') THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MRC0510 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(END)
                ENDDO
 
                IF         COND(&JOBTYPE = '1') THEN(DO)
                   SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             MRC0510 ended abnormally - see job log') +
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
