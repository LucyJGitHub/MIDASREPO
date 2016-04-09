/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO BSPL Execution - Global')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOBSPLEXG - BSPL Execution - Global                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BUG18886           DATE 30May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAS014             Date 10Aug05              */
/*                      CGP010  *CREATE    Date 17Jan05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG18886 - Non-standard codes exist in Midas Plus core      */
/*                  sources                                          */
/*       CAS014 - IAS21 The Effects of Changes in Foreign Exchange   */
/*                Rates                                              */
/*       CGP010 - Global BSPL                                        */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM( &RQTYP &RQID &RRQID +                             */        /*CAS014*/
/**********                   &ZONE +                                           */        /*CAS014*/
/**********                   &BRC &BRGRP &BRCON +                              */        /*CAS014*/
/**********                   &RPSET &HDPTH &CHART +                            */        /*CAS014*/
/**********                   &RELPN &CYR &CMTH    +                            */        /*CAS014*/
/**********                   &RPTYP &RMDUR +                                   */        /*CAS014*/
/**********                   &INTDTS +                                         */        /*CAS014*/
/**********                   &REPDTS +                                         */        /*CAS014*/
/**********                   &ACDBD &PRTZB &ROUND +                            */        /*CAS014*/
/**********                   &IFCTFR &IBCTFR      +                            */        /*CAS014*/
/**********                   &INSID &DESC &EXPRT  +                            */        /*CAS014*/
/**********                   &PCYR &PCMTH +                                    */        /*CAS014*/
/**********                   &CDATE &PCDATE +                                  */        /*CAS014*/
/**********                   &NEXTSEQ )                                        */        /*CAS014*/
             PGM        PARM( &RQTYP &RQID &RRQID +
                              &ZONE +
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
                              &INTREPDTS)                                                 /*CAS014*/
 
             DCL        VAR(&RQTYP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RQID)  TYPE(*CHAR) LEN(15)
             DCL        VAR(&RRQID) TYPE(*CHAR) LEN(15)
 
             DCL        VAR(&ZONE)     TYPE(*CHAR) LEN(10)
 
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
 
             DCL        VAR(&INTDTS)   TYPE(*CHAR) LEN(15)
             DCL        VAR(&INT)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&INTCCY)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&INTCNV)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&INTCZN)   TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&REPDTS)   TYPE(*CHAR) LEN(15)
             DCL        VAR(&REP)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&REPCCY)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&REPCNV)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&REPCZN)   TYPE(*CHAR) LEN(10)
 
/** CAS014 variables */                                                                   /*CAS014*/
                                                                                          /*CAS014*/
             DCL        VAR(&INTREPDTS) TYPE(*CHAR) LEN(14)                               /*CAS014*/
             DCL        VAR(&INCAV)    TYPE(*CHAR)  LEN(01)                               /*CAS014*/
             DCL        VAR(&INAPD)    TYPE(*CHAR)  LEN(02)                               /*CAS014*/
             DCL        VAR(&INAPE)    TYPE(*CHAR)  LEN(04)                               /*CAS014*/
             DCL        VAR(&RPCAV)    TYPE(*CHAR)  LEN(01)                               /*CAS014*/
             DCL        VAR(&RPAPD)    TYPE(*CHAR)  LEN(02)                               /*CAS014*/
             DCL        VAR(&RPAPE)    TYPE(*CHAR)  LEN(04)                               /*CAS014*/
                                                                                          /*CAS014*/
             DCL        VAR(&ACDBD)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTZB)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&ROUND)    TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&IFCTFR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&IBCTFR) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&INSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DESC)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&EXPRT) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&NEXTSEQ) TYPE(*CHAR) LEN(5)
 
             DCL        VAR(&RSNAME) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MAXLVL) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&ERMS)   TYPE(*CHAR) LEN(50)
             DCL        VAR(&SWS)    TYPE(*CHAR) LEN(8)
 
             DCL        VAR(&PCYR)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCMTH)   TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&CDATE)  TYPE(*DEC) LEN(5 0)
             DCL        VAR(&PCDATE) TYPE(*DEC) LEN(5 0)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
             CHGVAR     VAR(&INT)     VALUE(%SST(&INTDTS 1 1))
             CHGVAR     VAR(&INTCCY)  VALUE(%SST(&INTDTS 2 3))
             CHGVAR     VAR(&INTCNV)  VALUE(%SST(&INTDTS 5 1))
             CHGVAR     VAR(&INTCZN)  VALUE(%SST(&INTDTS 6 10))
 
             CHGVAR     VAR(&REP)     VALUE(%SST(&REPDTS 1 1))
             CHGVAR     VAR(&REPCCY)  VALUE(%SST(&REPDTS 2 3))
             CHGVAR     VAR(&REPCNV)  VALUE(%SST(&REPDTS 5 1))
             CHGVAR     VAR(&REPCZN)  VALUE(%SST(&REPDTS 6 10))
 
             CHGVAR     VAR(&INCAV) VALUE(%SST(&INTREPDTS 1 1))                           /*CAS014*/
             CHGVAR     VAR(&INAPD) VALUE(%SST(&INTREPDTS 2 2))                           /*CAS014*/
             CHGVAR     VAR(&INAPE) VALUE(%SST(&INTREPDTS 4 4))                           /*CAS014*/
                                                                                          /*CAS014*/
             CHGVAR     VAR(&RPCAV) VALUE(%SST(&INTREPDTS 8 1))                           /*CAS014*/
             CHGVAR     VAR(&RPAPD) VALUE(%SST(&INTREPDTS 9 2))                           /*CAS014*/
             CHGVAR     VAR(&RPAPE) VALUE(%SST(&INTREPDTS 11 4))                          /*CAS014*/
                                                                                          /*CAS014*/
             OVRDBF     FILE(GZSDBRCHL0) SHARE(*NO)
             OVRDBF     FILE(GZSDBRCHL1) SHARE(*NO)
 
             CLOF       OPNID(GPHIBLPD)
             MONMSG CPF0000
             CLOF       OPNID(GPBSPLHPD)
             MONMSG CPF0000
 
/* Create work files and do overrides to them */
 
             DLTF       FILE(QTEMP/GPBSPLBPD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/GPBSPLCPD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/GPBSPLHPD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/GPACBLRPD)
             MONMSG     MSGID(CPF0000)
 
             CRTDUPOBJ  OBJ(GPBSPLBPD) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) DATA(*NO)
             CRTDUPOBJ  OBJ(GPBSPLCPD) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) DATA(*NO)
             CRTDUPOBJ  OBJ(GPBSPLHPD) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) DATA(*NO)
             CRTDUPOBJ  OBJ(GPACBLRPD) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) DATA(*NO)
 
             OVRDBF     FILE(GPBSPLBPD) TOFILE(QTEMP/GPBSPLBPD) +
                          OVRSCOPE(*JOB)
             OVRDBF     FILE(GPBSPLCPD) TOFILE(QTEMP/GPBSPLCPD) +
                          OVRSCOPE(*JOB)
             OVRDBF     FILE(GPBSPLHPD) TOFILE(QTEMP/GPBSPLHPD) +
                          OVRSCOPE(*JOB)
             OVRDBF     FILE(GPACBLRPD) TOFILE(QTEMP/GPACBLRPD) +
                          OVRSCOPE(*JOB)
 
 
/* BSPL Branch Extract  ***********************************************************/
 
 
             CLRPFM     FILE(QTEMP/GPBSPLBPD)
 
             CALL       PGM(GOBSPLBEX) PARM(&RTCD &ERMS 'G' &ZONE &BRC &BRGRP)
             RCLACTGRP  ACTGRP(GOBSPLBEX)
 
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(GOTO CMDLBL(ABNOR))
 
 
/* BSPL Report Extract  ************************************************************/
 
             OVRDBF     FILE(GPACBLAPD) TOFILE(GPHIBLPD) SHARE(*YES) +
                          SEQONLY(*YES 1000)
 
             OPNQRYF    FILE((GPHIBLPD) (GPBSPLBPD)) FORMAT(GPACBLAPD) +
             QRYSLT('YR *EQ ' *CAT &CYR *CAT ' *AND PR *EQ ' *CAT &CMTH)     +
             KEYFLD(BRCA CCY ACOD EPBLDC)  +
             JFLD((BRCA A8BRCD)) +
             JDFTVAL(*NO) +
             GRPFLD(BRCA CCY ACOD EPBLDC)  +
             MAPFLD((ANLYSC   '" "         ') +
                    (SEPBLAC  '%SUM(EPBLAC)') +
                    (SBSTFR   '%SUM(BSTFR )') +
                    (SFCTFAC  '%SUM(FCTFAC)'))
 
             CLRPFM     FILE(QTEMP/GPBSPLCPD)
             CLRPFM     FILE(QTEMP/GPACBLRPD)
 
/**********  CALL       PGM(GOBSPLREX) PARM(&RTCD &ERMS 'G' &BRCON &INT &INTCCY &INTCNV &INTCZN +
/**********                     &REP &REPCCY &REPCNV &REPCZN &IFCTFR &IBCTFR &CDATE '1')   *CAS014*/
             CALL       PGM(GOBSPLREX) PARM(&RTCD &ERMS 'G' &BRCON &INT &INTCCY &INTCNV &INTCZN +
                                &REP &REPCCY &REPCNV &REPCZN &IFCTFR &IBCTFR &CDATE '1' +
                                &INCAV &INAPD &INAPE &RPCAV &RPAPD &RPAPE)                /*CAS014*/
 
             DLTOVR     FILE(GPACBLAPD)
             CLOF       OPNID(GPHIBLPD)
 
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(GOTO CMDLBL(ABNOR))
 
 
/* BSPL Report Extract  ************************************************************/
 
             IF         COND(&RPTYP = 'M') THEN(DO)
 
             OVRDBF     FILE(GPACBLAPD) TOFILE(GPHIBLPD) SHARE(*YES) +
                          SEQONLY(*YES 1000)
 
             OPNQRYF    FILE((GPHIBLPD) (GPBSPLBPD)) FORMAT(GPACBLAPD) +
             QRYSLT('YR *EQ ' *CAT &PCYR *CAT ' *AND PR *EQ ' *CAT &PCMTH)     +
             KEYFLD(BRCA CCY ACOD EPBLDC)  +
             JFLD((BRCA A8BRCD)) +
             JDFTVAL(*NO) +
             GRPFLD(BRCA CCY ACOD EPBLDC)  +
             MAPFLD((REPBLAC  'EPBLAC * -1') +
                    (RBSTFR   'BSTFR  * -1') +
                    (RFCTFAC  'FCTFAC * -1') +
                    (ANLYSC   '" "         ') +
                    (SEPBLAC  '%SUM(REPBLAC)') +
                    (SBSTFR   '%SUM(RBSTFR )') +
                    (SFCTFAC  '%SUM(RFCTFAC)'))
 
/**********  CALL       PGM(GOBSPLREX) PARM(&RTCD &ERMS 'G' &BRCON &INT &INTCCY &INTCNV &INTCZN +
/**********                     &REP &REPCCY &REPCNV &REPCZN &IFCTFR &IBCTFR &PCDATE '2')   CAS014*/
             CALL       PGM(GOBSPLREX) PARM(&RTCD &ERMS 'G' &BRCON &INT &INTCCY &INTCNV &INTCZN +
                                &REP &REPCCY &REPCNV &REPCZN &IFCTFR &IBCTFR &PCDATE '2' +
                                &INCAV &INAPD &INAPE &RPCAV &RPAPD &RPAPE)                /*CAS014*/
 
             DLTOVR     FILE(GPACBLAPD)
             CLOF       OPNID(GPHIBLPD)
 
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(GOTO CMDLBL(ABNOR))
 
             ENDDO
 
/* BSPL Hierarchies Extract - Global ********************************************************/
 
 
             CLRPFM     FILE(QTEMP/GPBSPLHPD)
 
             CALL       PGM(GOBSPLHXG) PARM(&RTCD &ERMS &RPSET &CHART &RSNAME &MAXLVL)
             RCLACTGRP  ACTGRP(GOBSPLHXG)
 
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(GOTO CMDLBL(ABNOR))
 
 
/* BSPL Report *******************************************************************************/
 
             OVRDBF     FILE((GPACBLZPD)) TOFILE(GPBSPLHPD) SHARE(*YES) +
                          SEQONLY(*YES 1000)
 
             IF         COND(&PRTZB = 'Y') THEN(DO)
             OPNQRYF    FILE((GPBSPLHPD) (GPACBLRPD)) +
                          FORMAT(GPACBLZPD) KEYFLD((1/A8BRCD) +
                          (1/A6CYCD) (GRHIER)) JFLD((1/A8BRCD +
                          2/BRCA) (1/A6CYCD 2/REPCCY) (GRACOD ACCD) +
                          (GRDRCR EPBLDC)) JDFTVAL(*YES) +
                          GRPFLD(A8BRCD A6CYCD GRHIER GRACOD +
                          GRDESC ANLYSC) MAPFLD((SREPCCYBAL +
                          '%SUM(REPCCYBAL)'))
                          ENDDO
 
/**********  IF         COND(&PRTZB *= 'Y') THEN(DO)                                */ /*BUG18886 */
             IF         COND(&PRTZB *NE 'Y') THEN(DO)                                  /*BUG18886 */
             OPNQRYF    FILE((GPBSPLHPD) (GPACBLRPD)) +
                          FORMAT(GPACBLZPD) KEYFLD((1/A8BRCD) +
                          (1/A6CYCD) (GRHIER)) JFLD((1/A8BRCD +
                          2/BRCA) (1/A6CYCD 2/REPCCY) (GRACOD ACCD) +
                          (GRDRCR EPBLDC)) JDFTVAL(*YES) +
                          GRPFLD(A8BRCD A6CYCD GRHIER GRACOD +
                          GRDESC ANLYSC) GRPSLT('SREPCCYBAL *NE 0') +
                          MAPFLD((SREPCCYBAL '%SUM(REPCCYBAL)'))
                          ENDDO
 
/**********  CALL PGM(GOBSPLRPT)   PARM(&RTCD &ERMS        +                    */        /*CAS014*/
/**********                             &RSNAME &MAXLVL    +                    */        /*CAS014*/
/**********                             &RQTYP &RQID &RRQID +                   */        /*CAS014*/
/**********                             'G'   &ZONE   +                         */        /*CAS014*/
/**********                             &BRC &BRGRP &BRCON +                    */        /*CAS014*/
/**********                             &RPSET &HDPTH &CHART +                  */        /*CAS014*/
/**********                             &RELPN &CYR &CMTH    +                  */        /*CAS014*/
/**********                             &RPTYP &RMDUR  +                        */        /*CAS014*/
/**********                             &INTDTS        +                        */        /*CAS014*/
/**********                             &REPDTS        +                        */        /*CAS014*/
/**********                             &ACDBD &PRTZB &ROUND +                  */        /*CAS014*/
/**********                             &IFCTFR &IBCTFR      +                  */        /*CAS014*/
/**********                             &INSID               +                  */        /*CAS014*/
/**********                             &DESC                +                  */        /*CAS014*/
/**********                             &EXPRT               +                  */        /*CAS014*/
/**********                             &NEXTSEQ           )                    */        /*CAS014*/
             CALL PGM(GOBSPLRPT)   PARM(&RTCD &ERMS        +
                                        &RSNAME &MAXLVL    +
                                        &RQTYP &RQID &RRQID +
                                        'G'   &ZONE   +
                                        &BRC &BRGRP &BRCON +
                                        &RPSET &HDPTH &CHART +
                                        &RELPN &CYR &CMTH    +
                                        &RPTYP &RMDUR  +
                                        &INTDTS        +
                                        &REPDTS        +
                                        &ACDBD &PRTZB &ROUND +
                                        &IFCTFR &IBCTFR      +
                                        &INSID               +
                                        &DESC                +
                                        &EXPRT               +
                                        &NEXTSEQ             +
                                        &INTREPDTS         )                              /*CAS014*/
 
             DLTOVR     FILE(GPACBLZPD)
             CLOF       OPNID(GPBSPLHPD)
 
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) *EQ '11') THEN(GOTO CMDLBL(ABNOR))
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/* Abnormal termination */
             CHGJOB     SWS(XXXXXX11)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
