/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO BSPL Immediate Report Execution')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0720 - BSPL Immediate Report Execution                   */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BUG18886           Date 30May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CAS014             Date 10Aug05              */
/*                      CGP010  *CREATE    Date 17Jan05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG18886 - Non-standard codes exist in Midas Plus core      */
/*                  sources                                          */
/*       CAS014 - IAS21 The Effects of Changes in Foreign Exchange   */
/*                Rates                                              */
/*       CGP010 - Global BSPL                                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RQID)
 
             DCL        VAR(&RQID) TYPE(*CHAR) LEN(15)
             DCL        VAR(&RRQID) TYPE(*CHAR) LEN(15)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(50)
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ZODNWD) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ZOBCCY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZONJOB) TYPE(*DEC) LEN(1 0)
 
             DCL        VAR(&REQUESTID) TYPE(*DEC ) LEN(15 0)
             DCL        VAR(&NEXTSEQ)   TYPE(*CHAR) LEN(5)
 
             DCL        VAR(&HDPTH )    TYPE(*CHAR) LEN(2)
             DCL        VAR(&RELPN )    TYPE(*CHAR) LEN(3)
             DCL        VAR(&CYR   )    TYPE(*CHAR) LEN(2)
             DCL        VAR(&CMTH  )    TYPE(*CHAR) LEN(2)
             DCL        VAR(&INTDTS)    TYPE(*CHAR) LEN(15)
             DCL        VAR(&REPDTS)    TYPE(*CHAR) LEN(15)
                                                                                          /*CAS014*/
 /** CAS014 Variable */                                                                   /*CAS014*/
                                                                                          /*CAS014*/
             DCL        VAR(&INTREPDTS) TYPE(*CHAR) LEN(14)                               /*CAS014*/
 
             DCL        VAR(&SWS)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
             DCLF       FILE(GPBSRQL2)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('GOC0720 - BSPL Immediate Report Execution') +
                          TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(00000000)
 
 
/* GET THE ZONE RUNNING THIS COMPONENT */
 
             CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                          &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                          &ZONJOB)
 
/* error */
/**********  IF         COND(&RTCD *= '       ') THEN(DO)                            */ /*BUG18886*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                              /*BUG18886*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
 
/* UPDATE CURRENT GLOBAL HISTORIC BALANCES (SUBMITTED)*/
 
 
             CALL       PGM(GOC0700) PARM('Y')
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(GOTO CMDLBL(ABNOR))
 
 
/* READ GPBSRQPD */
 
 REREAD:     RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))
 
 
/* IGNORE IF NOT REQUESTED ID */
 
             CHGVAR     VAR(&REQUESTID) VALUE(&RQID)
/**********  IF         COND(&SCRQID *= &REQUESTID) THEN(GOTO +
                          CMDLBL(REREAD))                                            */ /*BUG18886*/
             IF         COND(&SCRQID *NE &REQUESTID) THEN(GOTO +
                          CMDLBL(REREAD))                                               /*BUG18886*/
 
             CALL       PGM(GOBSPLREQ) PARM(&RTCD &ERMS &NEXTSEQ)
/* error */
/**********  IF         COND(&RTCD *= '       ') THEN(DO)                            */ /*BUG18886*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                              /*BUG18886*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
 
             CHGVAR     VAR(&HDPTH) VALUE(&SCHDPTH)
             CHGVAR     VAR(&RELPN) VALUE(&SCRELPN)
             CHGVAR     VAR(&CYR)   VALUE(&SCCYR)
             CHGVAR     VAR(&CMTH)  VALUE(&SCCMTH)
 
/**********  CHGVAR     VAR(&INTDTS) VALUE(&SCINT ** &SCINTCCY ** +
                          &SCINTCNV ** &SCINTCZN)                                    */ /*BUG18886*/
             CHGVAR     VAR(&INTDTS) VALUE(&SCINT *CAT &SCINTCCY *CAT +
                          &SCINTCNV *CAT &SCINTCZN)                                     /*BUG18886*/
/**********  CHGVAR     VAR(&REPDTS) VALUE(&SCREP ** &SCREPCCY ** +
                          &SCREPCNV ** &SCREPCZN)                                    */ /*BUG18886*/
             CHGVAR     VAR(&REPDTS) VALUE(&SCREP *CAT &SCREPCCY *CAT +
                          &SCREPCNV *CAT &SCREPCZN)                                     /*BUG18886*/
/**********  CHGVAR     VAR(&INTREPDTS) VALUE(&SCINCAV ** &SCINAPD +
                          ** &SCINAPE ** &SCRPCAV ** &SCRPAPD ** +
                          &SCRPAPE)                                          /*CAS014*/ /*BUG18886*/
             CHGVAR     VAR(&INTREPDTS) VALUE(&SCINCAV *CAT &SCINAPD +
                          *CAT &SCINAPE *CAT &SCRPCAV *CAT &SCRPAPD *CAT +
                          &SCRPAPE)                                                     /*BUG18886*/
 
 
/* BSPL REPORT EXECUTION (SUBMITTED)*/
 
/**********  CALL       PGM(GOBSPLEXC) PARM(&SCRQTYP &RQID &RRQID &SCZNGL +     */        /*CAS014*/
/**********               &SCBRC &SCBRGRP &SCBRCON &SCRPSET +                   */        /*CAS014*/
/**********               &HDPTH &SCCHART &RELPN &CYR &CMTH &SCRPTYP +          */        /*CAS014*/
/**********               &SCRMDUR &INTDTS &REPDTS &SCACDBD +                   */        /*CAS014*/
/**********               &SCPRTZB &SCROUND &SCIFCTFR &SCIBCTFR +               */        /*CAS014*/
/**********               &SCINSID &SCDESC &SCEXPRT 'Y' &NEXTSEQ)               */        /*CAS014*/
                                                                                          /*CAS014*/
             CALL       PGM(GOBSPLEXC) PARM(&SCRQTYP &RQID &RRQID &SCZNGL +
                          &SCBRC &SCBRGRP &SCBRCON &SCRPSET +
                          &HDPTH &SCCHART &RELPN &CYR &CMTH &SCRPTYP +
                          &SCRMDUR &INTDTS &REPDTS &SCACDBD +
                          &SCPRTZB &SCROUND &SCIFCTFR &SCIBCTFR +
                          &SCINSID &SCDESC &SCEXPRT 'Y' &NEXTSEQ +
                          &INTREPDTS)                                                     /*CAS014*/
 
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(GOTO CMDLBL(ABNOR))
 
 
/* BSPL ANALYSIS EXECUTION (SUBMITTED)*/
 
             IF         COND(&SCEXPRT = 'Y') THEN(DO)
 /********** CALL       PGM(GOBSANEXC) PARM(&SCRQTYP &RQID &RRQID &SCZNGL +     */        /*CAS014*/
 /**********              &SCBRC &SCBRGRP &SCBRCON &SCRPSET +                   */        /*CAS014*/
 /**********              &HDPTH &SCCHART &RELPN &CYR &CMTH &SCRPTYP +          */        /*CAS014*/
 /**********              &SCRMDUR &INTDTS &REPDTS &SCACDBD +                   */        /*CAS014*/
 /**********              &SCPRTZB &SCROUND &SCIFCTFR &SCIBCTFR +               */        /*CAS014*/
 /**********              &SCINSID &SCDESC &SCEXPRT 'Y' &NEXTSEQ)               */        /*CAS014*/
                                                                                          /*CAS014*/
             CALL       PGM(GOBSANEXC) PARM(&SCRQTYP &RQID &RRQID &SCZNGL +
                          &SCBRC &SCBRGRP &SCBRCON &SCRPSET +
                          &HDPTH &SCCHART &RELPN &CYR &CMTH &SCRPTYP +
                          &SCRMDUR &INTDTS &REPDTS &SCACDBD +
                          &SCPRTZB &SCROUND &SCIFCTFR &SCIBCTFR +
                          &SCINSID &SCDESC &SCEXPRT 'Y' &NEXTSEQ +
                          &INTREPDTS)                                                     /*CAS014*/
 
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(GOTO CMDLBL(ABNOR))
             ENDDO
 
 
/* DELETE RECORD */
 
             CALL       PGM(GOBSRQDEL) PARM(&RTCD &ERMS &SCRQTYP +
                          &SCRQID)
 
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(GOTO CMDLBL(ABNOR))
 
 
             GOTO       CMDLBL(REREAD)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GOC0720 ended abnormally - see job log') +
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
             ENDPGM
