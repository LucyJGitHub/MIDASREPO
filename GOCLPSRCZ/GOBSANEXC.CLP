/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO BSPL Analysis Execution')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOBSANEXC - BSPL Analysis Execution                         */
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
/**********  PGM        PARM( &RQTYP &RQID &RRQID +                             */        /*CAS014*/
/**********                   &ZNGL +                                           */        /*CAS014*/
/**********                   &BRC &BRGRP &BRCON +                              */        /*CAS014*/
/**********                   &RPSET &HDPTH &CHART +                            */        /*CAS014*/
/**********                   &RELPN &CYR &CMTH    +                            */        /*CAS014*/
/**********                   &RPTYP &RMDUR +                                   */        /*CAS014*/
/**********                   &INTDTS +                                         */        /*CAS014*/
/**********                   &REPDTS +                                         */        /*CAS014*/
/**********                   &ACDBD &PRTZB &ROUND +                            */        /*CAS014*/
/**********                   &IFCTFR &IBCTFR      +                            */        /*CAS014*/
/**********                   &INSID &DESC &EXPRT  +                            */        /*CAS014*/
/**********                   &SUBMIT              +                            */        /*CAS014*/
/**********                   &NEXTSEQ )                                        */        /*CAS014*/
             PGM        PARM( &RQTYP &RQID &RRQID  +
                              &ZNGL                +
                              &BRC &BRGRP &BRCON   +
                              &RPSET &HDPTH &CHART +
                              &RELPN &CYR &CMTH    +
                              &RPTYP &RMDUR        +
                              &INTDTS              +
                              &REPDTS              +
                              &ACDBD &PRTZB &ROUND +
                              &IFCTFR &IBCTFR      +
                              &INSID &DESC &EXPRT  +
                              &SUBMIT              +
                              &NEXTSEQ             +
                              &INTREPDTS)                                                 /*CAS014*/
 
             DCL        VAR(&RQTYP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RQID)  TYPE(*CHAR) LEN(15)
             DCL        VAR(&RRQID) TYPE(*CHAR) LEN(15)
 
             DCL        VAR(&ZNGL) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&BRC)      TYPE(*CHAR) LEN(3)
             DCL        VAR(&BRGRP)    TYPE(*CHAR) LEN(15)
             DCL        VAR(&BRCON)    TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&RPSET)    TYPE(*CHAR) LEN(15)
             DCL        VAR(&HDPTH)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&CHART)    TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&RELPN)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&CYR)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&CMTH)    TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&RPTYP)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RMDUR)  TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&INTDTS)    TYPE(*CHAR) LEN(15)
             DCL        VAR(&REPDTS)    TYPE(*CHAR) LEN(15)
                                                                                          /*CAS014*/
 /** CAS014 Variable */                                                                   /*CAS014*/
                                                                                          /*CAS014*/
             DCL        VAR(&INTREPDTS) TYPE(*CHAR) LEN(14)                               /*CAS014*/
 
             DCL        VAR(&ACDBD)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTZB)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&ROUND)    TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&IFCTFR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&IBCTFR) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&INSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DESC)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&EXPRT) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&SUBMIT) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&NEXTSEQ) TYPE(*CHAR) LEN(5)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(50)
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ZODNWD) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ZOBCCY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZONJOB) TYPE(*DEC) LEN(1 0)
 
             DCL        VAR(&PCYR)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCMTH)   TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&CDATE)  TYPE(*DEC) LEN(5 0)
             DCL        VAR(&PCDATE) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&LDA)    TYPE(*CHAR) LEN(256)                                 /*CAS014*/
 
             DCL        VAR(&SWS)    TYPE(*CHAR) LEN(8)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/* Set up LDA for IC request */                                                           /*CAS014*/
             IF         COND(&RQTYP *EQ 'I') THEN(DO)                                     /*CAS014*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)                            /*CAS014*/
             MONMSG     MSGID(CPF1023)                                                    /*CAS014*/
             ENDDO                                                                        /*CAS014*/
 
/* SUBMIT (IF REQUIRED) */
 
             IF         COND(&SUBMIT = 'Y') THEN(DO)
/**********  SBMJOB JOB(BSPLEXPORT) CMD( +                                      */        /*CAS014*/
/**********  CALL PGM(GOBSANEXC)                 +                              */        /*CAS014*/
/**********                   PARM( &RQTYP &RQID &RRQID +                       */        /*CAS014*/
/**********                   &ZNGL +                                           */        /*CAS014*/
/**********                   &BRC &BRGRP &BRCON +                              */        /*CAS014*/
/**********                   &RPSET &HDPTH &CHART +                            */        /*CAS014*/
/**********                   &RELPN &CYR &CMTH    +                            */        /*CAS014*/
/**********                   &RPTYP &RMDUR +                                   */        /*CAS014*/
/**********                   &INTDTS +                                         */        /*CAS014*/
/**********                   &REPDTS +                                         */        /*CAS014*/
/**********                   &ACDBD &PRTZB &ROUND +                            */        /*CAS014*/
/**********                   &IFCTFR &IBCTFR      +                            */        /*CAS014*/
/**********                   &INSID &DESC &EXPRT  +                            */        /*CAS014*/
/**********                   'N'                  +                            */        /*CAS014*/
/**********                   &NEXTSEQ ) ) +                                    */        /*CAS014*/
/**********  JOBD(MBATCH) RTGDTA(*JOBD) OUTQ(*JOBD) INLLIBL(*JOBD) USER(*JOBD)  */        /*CAS014*/
             SBMJOB JOB(BSPLEXPORT) CMD( +
             CALL PGM(GOBSANEXC)                 +
                              PARM( &RQTYP &RQID &RRQID +
                              &ZNGL +
                              &BRC &BRGRP &BRCON +
                              &RPSET &HDPTH &CHART +
                              &RELPN &CYR &CMTH    +
                              &RPTYP &RMDUR +
                              &INTDTS +
                              &REPDTS +
                              &ACDBD &PRTZB &ROUND +
                              &IFCTFR &IBCTFR      +
                              &INSID &DESC &EXPRT  +
                              'N'                  +
                              &NEXTSEQ     +
                              &INTREPDTS) ) +
             JOBD(MBATCH) RTGDTA(*JOBD) OUTQ(*JOBD) INLLIBL(*JOBD) USER(*JOBD)            /*CAS014*/
             RETURN
             ENDDO
 
 
/* GET THE ZONE RUNNING THE REPORT */
 
                CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                             &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                             &ZONJOB)
/**********     IF         COND(&RTCD *= '       ') THEN(DO)                       */ /* BUG18886 */
                IF         COND(&RTCD *NE '       ') THEN(DO)                         /* BUG18886 */
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
 
/* DETERMINE DATES TO EXTRACT */
 
             CALL PGM(GOBSPLDEX)   PARM(&RTCD &ERMS &CYR &CMTH &RPTYP &RMDUR +
                                        &CDATE &PCDATE &PCYR &PCMTH)
 
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(GOTO CMDLBL(ABNOR))
 
 
/* RUN ZONE BSPL ANALYSIS */
 
             IF         COND(&ZNGL = 'Z') THEN(DO)
/**********  CALL PGM(GOBSANEXZ)   PARM(&RQTYP &RQID &RRQID +                   */        /*CAS014*/
/**********                             &ZOZONE +                               */        /*CAS014*/
/**********                             &BRC &BRGRP &BRCON +                    */        /*CAS014*/
/**********                             &RPSET &HDPTH &CHART +                  */        /*CAS014*/
/**********                             &RELPN &CYR &CMTH    +                  */        /*CAS014*/
/**********                             &RPTYP &RMDUR +                         */        /*CAS014*/
/**********                             &INTDTS +                               */        /*CAS014*/
/**********                             &REPDTS +                               */        /*CAS014*/
/**********                             &ACDBD &PRTZB &ROUND +                  */        /*CAS014*/
/**********                             &IFCTFR &IBCTFR      +                  */        /*CAS014*/
/**********                             &INSID &DESC &EXPRT  +                  */        /*CAS014*/
/**********                             &PCYR &PCMTH +                          */        /*CAS014*/
/**********                             &CDATE &PCDATE +                        */        /*CAS014*/
/**********                             &NEXTSEQ )                              */        /*CAS014*/
             CHGVAR     VAR(&INTREPDTS) VALUE(' ')
             CALL PGM(GOBSANEXZ)   PARM(&RQTYP &RQID &RRQID +
                                        &ZOZONE +
                                        &BRC &BRGRP &BRCON +
                                        &RPSET &HDPTH &CHART +
                                        &RELPN &CYR &CMTH    +
                                        &RPTYP &RMDUR +
                                        &INTDTS +
                                        &REPDTS +
                                        &ACDBD &PRTZB &ROUND +
                                        &IFCTFR &IBCTFR      +
                                        &INSID &DESC &EXPRT  +
                                        &PCYR &PCMTH +
                                        &CDATE &PCDATE +
                                        &NEXTSEQ       +
                                        &INTREPDTS)                                       /*CAS014*/
             ENDDO
 
 
/* RUN GLOBAL BSPL ANALYSIS */
 
             IF         COND(&ZNGL = 'G') THEN(DO)
 /********** CALL PGM(GOBSANEXG)   PARM(&RQTYP &RQID &RRQID +                   */        /*CAS014*/
 /**********                            &ZOZONE +                               */        /*CAS014*/
 /**********                            &BRC &BRGRP &BRCON +                    */        /*CAS014*/
/**********                             &RPSET &HDPTH &CHART +                  */        /*CAS014*/
/**********                             &RELPN &CYR &CMTH    +                  */        /*CAS014*/
/**********                             &RPTYP &RMDUR +                         */        /*CAS014*/
/**********                             &INTDTS +                               */        /*CAS014*/
/**********                             &REPDTS +                               */        /*CAS014*/
/**********                             &ACDBD &PRTZB &ROUND +                  */        /*CAS014*/
/**********                             &IFCTFR &IBCTFR      +                  */        /*CAS014*/
/**********                             &INSID &DESC &EXPRT  +                  */        /*CAS014*/
/**********                             &PCYR &PCMTH +                          */        /*CAS014*/
/**********                             &CDATE &PCDATE +                        */        /*CAS014*/
/**********                             &NEXTSEQ )                              */        /*CAS014*/
             CALL PGM(GOBSANEXG)   PARM(&RQTYP &RQID &RRQID +
                                        &ZOZONE +
                                        &BRC &BRGRP &BRCON +
                                        &RPSET &HDPTH &CHART +
                                        &RELPN &CYR &CMTH    +
                                        &RPTYP &RMDUR +
                                        &INTDTS +
                                        &REPDTS +
                                        &ACDBD &PRTZB &ROUND +
                                        &IFCTFR &IBCTFR      +
                                        &INSID &DESC &EXPRT  +
                                        &PCYR &PCMTH +
                                        &CDATE &PCDATE +
                                        &NEXTSEQ       +
                                        &INTREPDTS)                                       /*CAS014*/
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/* Abnormal termination */
             CHGJOB     SWS(XXXXXX11)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
