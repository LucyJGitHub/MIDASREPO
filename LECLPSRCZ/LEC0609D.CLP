/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Facility amendment processing')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0609D - Manual Utilisation Processing                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR402546           Date 31Jul12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 223967             Date 06Jun06              */
/*                      CLE106             Date 01Aug04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CLE023             Date 19Nov01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      154584             Date 18Feb99              */
/*                      127714             Date 18Nov97              */
/*                      CLE005 *CREATE     Date 22May97              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR402546 - LEFCAMPD should be reorganize every COB to avoid */
/*                  COB time processing issue.                       */
/*       223967 - Facility amount not updated when amendments are    */
/*                processed.  Add processing for EMXT4F1 file.       */
/*       CLE106 - Syndications Manager                               */
/*       CLE023 - Lending Facility History Improvements.             */
/*       154584 - Clears File FCUPDFM                                */
/*       127714 - Update Trailer File                                */
/*       CLE005 - Customer Lending Enhancements - Others (T3)        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CLE023*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CLE023*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CLE023*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CLE023*/
             DCL        VAR(&CLE023) TYPE(*CHAR) LEN(1)                                   /*CLE023*/
                                                                                          /*CLE023*/
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('Facility Amendments Processing') +
                          TOMSGQ(MRUNQ)
                                                                                          /*CLE023*/
/** Access SAR file to determine if switchable feature CLE023     */                      /*CLE023*/
/** is switched ON                                                */                      /*CLE023*/
                                                                                          /*CLE023*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE023*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CLE023*/
             CHGVAR     VAR(&SAR) VALUE('CLE023')                                         /*CLE023*/
             CHGVAR     VAR(&CLE023) VALUE('N')                                           /*CLE023*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CLE023*/
                                                                                          /*CLE023*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CLE023*/
                CHGVAR     VAR(&CLE023) VALUE('Y')
             ENDDO                                                                        /*CLE023*/
 
/* Check the current status of this component */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
/* If this is not a restart, copy master files to backup files */
 
             IF         COND(&STAT *EQ 'N') THEN(DO)
                CPYF       FROMFILE(LEFCAMPD) TOFILE(XLEFCAMPD) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XLEFCAMPD))
                CPYF       FROMFILE(LEFCAMZZ) TOFILE(XLEFCAMZZ) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XLEFCAMZZ))
                CPYF       FROMFILE(FACACT) TOFILE(XFACACT) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XFACACT))
                CPYF       FROMFILE(HISACT) TOFILE(XHISACT) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XHISACT))
                CPYF       FROMFILE(FCLTYFM) TOFILE(XFCLTYFM) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XFCLTYFM))
                CPYF       FROMFILE(FCLTYFN) TOFILE(XFCLTYFN) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XFCLTYFN))
                CPYF       FROMFILE(FCLTYZZ) TOFILE(XFCLTYZZ) +
                             MBROPT(*REPLACE)                         /*127714*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XFCLTYZZ))                          /*127714*/
                CPYF       FROMFILE(EMXT4F1) TOFILE(XEMXT4F1) +
                           MBROPT(*REPLACE)                                               /*223967*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(XEMXT4F1))                                                /*223967*/
                CPYF       FROMFILE(LEFNPRPD) TOFILE(XLEFNPRPD) +
                             MBROPT(*REPLACE)                                             /*CLE106*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XLEFNPRPD))                                             /*CLE106*/
 
                IF         COND(&CLE023 *EQ 'Y') THEN(DO)                                 /*CLE023*/
                   CPYF       FROMFILE(FACHISH) TOFILE(XFACHISH) +
                             MBROPT(*REPLACE)                                             /*CLE023*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XFACHISH))                                              /*CLE023*/
                ENDDO                                                                     /*CLE023*/
                                                                                          /*CLE023*/
                CHGVAR     VAR(&STAT) VALUE('Y')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
 
/* If this is a restart, restore master files */
 
             ELSE       CMD(DO)
 
                CPYF       FROMFILE(XLEFCAMPD) TOFILE(LEFCAMPD) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(LEFCAMPD))
                CPYF       FROMFILE(XLEFCAMZZ) TOFILE(LEFCAMZZ) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(LEFCAMZZ))
                CPYF       FROMFILE(XFACACT) TOFILE(FACACT) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(FACACT))
                CPYF       FROMFILE(XHISACT) TOFILE(HISACT) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(HISACT))
                CPYF       FROMFILE(XFCLTYFM) TOFILE(FCLTYFM) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(FCLTYFM))
                CPYF       FROMFILE(XFCLTYFN) TOFILE(FCLTYFN) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(FCLTYFN))
                CPYF       FROMFILE(XFCLTYZZ) TOFILE(FCLTYZZ) +
                             MBROPT(*REPLACE)                         /*127714*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(FCLTYZZ))                           /*127714*/
                CPYF       FROMFILE(XEMXT4F1) TOFILE(EMXT4F1) +
                             MBROPT(*REPLACE)                                             /*223967*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(EMXT4F1))                                               /*223967*/
                CPYF       FROMFILE(XLEFNPRPD) TOFILE(LEFNPRPD) +
                             MBROPT(*REPLACE)                                             /*CLE106*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(LEFNPRPD))                                              /*CLE106*/
                                                                                          /*CLE023*/
                IF         COND(&CLE023 *EQ 'Y') THEN(DO)                                 /*CLE023*/
                   CPYF       FROMFILE(XFACHISH) TOFILE(FACHISH) +
                                MBROPT(*REPLACE)                                          /*CLE023*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                                FILE(FACHISH))                                            /*CLE023*/
                ENDDO                                                                     /*CLE023*/
             ENDDO
 
/* Call Facility Amendments Processing */
 
             CALL       PGM(LE0496)
 
/* No database error */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGVAR     VAR(&STAT) VALUE('N')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
                CLRPFM     FILE(FCUPDFM)                              /*154584*/
                                                                                        /*AR402546*/
                CALL       PGM(SCC000060) PARM('LEFCAMPD' '*FIRST')                     /*AR402546*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                           CMDLBL(ABNOR))                                               /*AR402546*/
             ENDDO
 
/* Database error processing */
 
             ELSE       CMD(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             LEC0609D ended abnormally - see job log') +
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
