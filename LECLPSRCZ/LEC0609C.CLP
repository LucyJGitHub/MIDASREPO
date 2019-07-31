/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Manual Utilisation Processing')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0609C - Manual Utilisation Processing                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1042505          Date 24Apr13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      228542             Date 10Aug04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CLE023             Date 19Nov01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CLE005 *Create     Date 03Jun97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1042505 - MFU is not included on rebuild of fclty exposure*/
/*                   Create a backup of LEMNFUPD before call to      */
/*                   LE0495. (Child: AR1042506)                      */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CLE023 - Lending Facility History Improvements.             */
/*       CLE005 - Customer Lending Enhancements - Others (T3)        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CLE023*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CLE023*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CLE023*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CLE023*/
             DCL        VAR(&CLE023) TYPE(*CHAR) LEN(1)                                   /*CLE023*/
                                                                                          /*CLE023*/
/*/COPY WNCPYSRC,LEC0609C01                                          */
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('Manual Utilisation Processing') +
                          TOMSGQ(MRUNQ)
/**/                                                                                      /*CLE023*/
/* Access SAR file to determine if switchable feature CLE023 */                           /*CLE023*/
/* is switched ON */                                                                      /*CLE023*/
/**/                                                                                      /*CLE023*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE023*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CLE023*/
             CHGVAR     VAR(&SAR) VALUE('CLE023')                                         /*CLE023*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CLE023*/
                                                                                          /*CLE023*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CLE023*/
                CHGVAR     VAR(&CLE023) VALUE('Y')
             ENDDO                                                                        /*CLE023*/
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
/*/COPY WNCPYSRC,LEC0609C02                                          */
 
             IF         COND(&STAT *EQ 'N') THEN(DO)
             CPYF       FROMFILE(LEMNFUPD) TOFILE(XLEMNFUPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XLEMNFUPD))
             CPYF       FROMFILE(LEMNFUZZ) TOFILE(XLEMNFUZZ) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XLEMNFUZZ))
             CPYF       FROMFILE(FACACT) TOFILE(XFACACT) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XFACACT))
             CPYF       FROMFILE(FCLTYHH) TOFILE(XFCLTYHH) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XFCLTYHH))
             CPYF       FROMFILE(FCLTYFM) TOFILE(XFCLTYFM) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XFCLTYFM))
             CPYF       FROMFILE(FCLTYFN) TOFILE(XFCLTYFN) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XFCLTYFN))
             CPYF       FROMFILE(FCLTYZZ) TOFILE(XFCLTYZZ) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XFCLTYZZ))
             CPYF       FROMFILE(HISACT) TOFILE(XHISACT) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XHISACT))
                                                                                          /*CLE023*/
             IF         COND(&CLE023 *EQ 'Y') THEN(DO)                                    /*CLE023*/
                CPYF       FROMFILE(FACHISH) TOFILE(XFACHISH) +
                          MBROPT(*REPLACE)                                                /*CLE023*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XFACHISH))                                                 /*CLE023*/
             ENDDO                                                                        /*CLE023*/
                                                                                          /*CLE023*/
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
 
 
             ELSE       CMD(DO)
             CPYF       FROMFILE(XLEMNFUPD) TOFILE(LEMNFUPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LEMNFUPD))
             CPYF       FROMFILE(XLEMNFUZZ) TOFILE(LEMNFUZZ) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LEMNFUZZ))
             CPYF       FROMFILE(XFACACT) TOFILE(FACACT) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(FACACT))
             CPYF       FROMFILE(XFCLTYHH) TOFILE(FCLTYHH) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(FCLTYHH))
             CPYF       FROMFILE(XFCLTYFM) TOFILE(FCLTYFM) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(FCLTYFM))
             CPYF       FROMFILE(XFCLTYFN) TOFILE(FCLTYFN) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(FCLTYFN))
             CPYF       FROMFILE(XFCLTYZZ) TOFILE(FCLTYZZ) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(FCLTYZZ))
             CPYF       FROMFILE(XHISACT) TOFILE(HISACT) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(HISACT))
                                                                                          /*CLE023*/
             IF         COND(&CLE023 *EQ 'Y') THEN(DO)                                    /*CLE023*/
                CPYF       FROMFILE(XFACHISH) TOFILE(FACHISH) +
                             MBROPT(*REPLACE)                                             /*CLE023*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(FACHISH))                                               /*CLE023*/
             ENDDO                                                                        /*CLE023*/
             ENDDO
 
             CPYF       FROMFILE(LEMNFUPD) TOFILE(LEMFUXPD) +
                          MBROPT(*REPLACE)                                             /*AR1042505*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LEMFUXPD))                                              /*AR1042505*/
/* Do a call to LE0495 */
 
             CALL       PGM(LE0495)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(SNDPGMMSG +
                          MSG('Job terminated, database in error.') +
                          TOMSGQ(MRUNQ MOPERQ))
 
             ELSE       CMD(DO)
 
/**********  RGZPFM     FILE(LEMNFUPD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('LEMNFUPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
                                                                                          /*228542*/
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             GOTO       CMDLBL(END)
             ENDDO
 
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          LEC0609C ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
