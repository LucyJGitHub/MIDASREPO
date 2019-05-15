/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO Universal transactions update - COB')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0020 - Universal Transactions Update - COB               */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CGP014             Date 27Feb09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BUG18886           Date 30May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG7395            Date 18Nov05              */
/*                      CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CGP014 - Task split of Extract Controller, Customer Loans   */
/*       BUG18886 - Non-standard codes exist in Midas Plus core      */
/*                  sources                                          */
/*       BUG7395 - Problems with object locking in CoB               */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SMOD)
 
             DCL        VAR(&SMOD) TYPE(*CHAR) LEN(4)
 
             DCL        VAR(&PGM ) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(50)
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZODNWD)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZOBCCY)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZONJOB)  TYPE(*DEC)  LEN(1 0)
 
             DCL        VAR(&LOC ) TYPE(*CHAR) LEN(4)  VALUE('ZONE')
             DCL        VAR(&CCID) TYPE(*DEC) LEN(10) VALUE(0)
 
             DCL        VAR(&EXTT) TYPE(*CHAR) LEN( 4) VALUE('*ALL')
 
             DCL        VAR(&CNUM) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&PTFR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BRCA) TYPE(*CHAR) LEN(3)
             DCL        VAR(&BOOK) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ACCY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ACOD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ACSQ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SESN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MKTI) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ISTT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&YRNO) TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&MTHN) TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&PCAL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&STRP) TYPE(*DEC)  LEN(15 8)
             DCL        VAR(&TREF) TYPE(*CHAR) LEN(20)
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('GOC0020 - Universal Transactions +
                          Update - ' *CAT &SMOD) TOMSGQ(MRUNQ)
/********                                                                         /*BUG7395 CGP014*/
/**Check*if files available */                                                    /*BUG7395 CGP014*/
/********    ALCOBJ     OBJ((GOWEVNTPD *FILE *EXCL)) WAIT(300)                    /*BUG7395 CGP014*/
/********    MONMSG     MSGID(CPF0000) EXEC(DO)                                   /*BUG7395 CGP014*/
/********       GOTO       CMDLBL(ABNOR)                                          /*BUG7395 CGP014*/
/********    ENDDO                                                                /*BUG7395 CGP014*/
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
 
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)
 
/* Get zone */
 
             CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                          &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                          &ZONJOB)
 
/* error */
/**********  IF         COND(&RTCD *= '       ') THEN(DO)                           */ /*BUG18886 */
             IF         COND(&RTCD *NE '       ') THEN(DO)                             /*BUG18886 */
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* clear files */
/*   but only if program is invoked interactively                                         /*CGP014*/
             IF         COND(&JOBTYPE = '1') THEN(DO)                                     /*CGP014*/
             CLRPFM     FILE(GOTRAPPD) MBR(&SMOD)
             CLRPFM     FILE(GOPOSNPD) MBR(&SMOD)
             CLRPFM     FILE(GOCASHPD) MBR(&SMOD)
 
             CLRPFM     FILE(GOWPOSNPD) MBR(&SMOD)
             CLRPFM     FILE(GOWEVNTPD) MBR(&SMOD)
             ENDDO                                                                        /*CGP014*/
 
/* overrides */
             OVRDBF     FILE(GOTRAPPD) MBR(&SMOD) SHARE(*NO) +
                          SEQONLY(*YES 1000)
             OVRDBF     FILE(GOPOSNPD) MBR(&SMOD) SHARE(*NO) +
                          SEQONLY(*YES 1000)
             OVRDBF     FILE(GOCASHPD) MBR(&SMOD) SHARE(*NO) +
                          SEQONLY(*YES 1000)
 
             OVRDBF     FILE(GOWPOSNPD) MBR(&SMOD) SHARE(*NO) +
                          SEQONLY(*YES 1000)
             OVRDBF     FILE(GOWEVNTPD) MBR(&SMOD) SHARE(*NO)
 
             OVRDBF     FILE(DEALSX) TOFILE(DEALS) SHARE(*NO)
             OVRDBF     FILE(CLOAN ) TOFILE(CLOAN) SHARE(*NO)
             OVRDBF     FILE(CLOANX) TOFILE(CLOAN) SHARE(*NO)
             OVRDBF     FILE(CLOANS) TOFILE(CLOAN) SHARE(*NO)
 
/*RETURN*/
             CHGVAR     VAR(&PGM) VALUE('GOXC' *CAT &SMOD)
             CALL       PGM(&PGM) PARM(&RTCD &ERMS &LOC &ZOZONE +
                          &CCID &EXTT &CNUM &PTFR &BRCA &BOOK &ACCY +
                          &ACOD &ACSQ &SESN &MKTI &ISTT &YRNO &MTHN +
                          &PCAL &STRP &TREF)
 
             DLTOVR *ALL
 
/* error */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                IF         COND(&JOBTYPE = '0') THEN(DO)
                  SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                               GOC0020 ended abnormally - see job log') +
                               TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
               IF         COND(&JOBTYPE = '1') THEN(DO)
                  ROLLBACK
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
                            GOC0020 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
                ROLLBACK
                MONMSG     MSGID(CPF0000 MCH0000)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             DLCOBJ     OBJ((GOWEVNTPD *FILE *EXCL))                                     /*BUG7395*/
             MONMSG     MSGID(CPF0000 MCH0000)                                           /*BUG7395*/
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
