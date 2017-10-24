/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Events file creation')                       */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0607 - EVENTS FILE CREATION                             */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CGL187             Date 06Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Prev Amend No. CDL008             Date 02May00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E22738             Date 16Aug90              */
/*                      E20                Date 01Nov89              */
/*                        S01117           DATE 18/07/89            */
/*                        S01194           DATE 18/07/89            */
/*                    .   S01179           DATE 12/09/88            */
/*                        S01095           DATE 22/09/86            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CGL187 - Amendment to Net Trading Position Report          */
/*       CDL008 - Continuous Linked Settlement                       */
/*       E22738  -  FILES NO LONGER IN USE.(DONE BY E20)            */
/*       E20     -  MODIFICATION: REMOVE MEMBERS FROM EVENT LF'S.   */
/*       S01117  -  MULTIBRANCHING                                  */
/*       S01194  -  STANDING DATA CHANGES.                          */
/*       S01179  -  AS400 CONVERSION                                */
/*       S01095  -  OUTPUT FILES BLOCKED                            */
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
/*********   DCLDTAARA  DTAARA(MMOD)                                    S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CDL008*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CDL008*/
             DCL        VAR(&SAR)    TYPE(*CHAR) LEN(6)               /*CDL008*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CDL008*/
             DCL        VAR(&CDL008) TYPE(*CHAR) LEN(1) VALUE('N')    /*CDL008*/
             DCL        VAR(&CGL187) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CGL187*/
/*/COPY WNCPYSRC,DLC0607003                                          */
/*********   RCVDTAARA  DTAARA(MMOD)                                    S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
             CHGVAR     VAR(&SAR) VALUE('CGL187')                                         /*CGL187*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CGL187*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CGL187*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                        VAR(&CGL187) VALUE('Y'))                                          /*CGL187*/
/**/
/*/COPY WNCPYSRC,DLC0607002                                          */
             CHGJOB     SWS(00000000)
/*********   SNDMSG     MSG('EVENTS FILE CREATION')   TOMSGQ(MRUNQ)   /*E20*/
/*********   RMVM       FILE(EVENT) MBR(EVENT)                        /*E20*/
/*********   MONMSG     MSGID(CPF0000)                                /*E20*/
/*********   RMVM       FILE(EVNT1) MBR(EVNT1)                        /*E20*/
/*********   MONMSG     MSGID(CPF0000)                                /*E20*/
/*********   RMVM       FILE(EVNT2) MBR(EVNT2)                        /*E20*/
/*********   MONMSG     MSGID(CPF0000)                                /*E20*/
/*********   RMVM       FILE(EVNT3) MBR(EVNT3)                        /*E20*/
/*********   MONMSG     MSGID(CPF0000)                                /*E20*/
/*********   RMVM       FILE(EVNTM) MBR(EVNTM)                        /*E20*/
/*********   MONMSG     MSGID(CPF0000)                                /*E20*/
/*********   RMVM       FILE(EVNTD) MBR(EVNTD)                        /*E20*/
/*********   MONMSG     MSGID(CPF0000)                                /*E20*/
/*********   RMVM       FILE(EVLSC) MBR(EVLSC)                        /*E20*/
/*********   MONMSG     MSGID(CPF0000)                                /*E20*/
/*********   RMVM       FILE(EVLSR) MBR(EVLSR)                        /*E20*/
/*********   MONMSG     MSGID(CPF0000)                                /*E20*/
/*********   RMVM       FILE(EVLSX) MBR(EVLSX)                        /*E20*/
/*********   MONMSG     MSGID(CPF0000)                                /*E20*/
/**                                                            S01117*/
/**   RMVM ON ALL LOGICAL FILES BUILT OVER EVNTXED             S01117*/
/**                                                            S01117*/
/*********   RMVM       FILE(ACCEXAN) MBR(ACCEXAN)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVDLS) MBR(EVDLS)               /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVDLSL1) MBR(EVDLSL1)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVENTA) MBR(EVENTA)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVENT2) MBR(EVENT2)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVENT3) MBR(EVENT3)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVFXS) MBR(EVFXS)               /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVFXSL1) MBR(EVFXSL1)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLACB) MBR(EVLACB)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLACO) MBR(EVLACO)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLBBA) MBR(EVLBBA)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLBBN) MBR(EVLBBN)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLBBP) MBR(EVLBBP)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLBBR) MBR(EVLBBR)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLCBA) MBR(EVLCBA)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLCBN) MBR(EVLCBN)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLCBP) MBR(EVLCBP)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLCBR) MBR(EVLCBR)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLCOA) MBR(EVLCOA)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLCON) MBR(EVLCON)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLCOP) MBR(EVLCOP)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLCOR) MBR(EVLCOR)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLNCB) MBR(EVLNCB)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLNCO) MBR(EVLNCO)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLOBA) MBR(EVLOBA)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLOBN) MBR(EVLOBN)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLOBP) MBR(EVLOBP)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLOBR) MBR(EVLOBR)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLPCB) MBR(EVLPCB)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLPCO) MBR(EVLPCO)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLRCB) MBR(EVLRCB)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVLRCO) MBR(EVLRCO)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNTJL1) MBR(EVNTJL1)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNTL2) MBR(EVNTL2)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNTL5) MBR(EVNTL5)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNTML3) MBR(EVNTML3)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNTML4) MBR(EVNTML4)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNTML5) MBR(EVNTML5)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNTML6) MBR(EVNTML6)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNTML1) MBR(EVNTML1)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNTML2) MBR(EVNTML2)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNTP) MBR(EVNTP)               /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNT1J) MBR(EVNT1J)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNT1L1) MBR(EVNT1L1)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNT1L1R) MBR(EVNT1L1R)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNT1L2) MBR(EVNT1L2)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNT1L2R) MBR(EVNT1L2R)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNT1R) MBR(EVNT1R)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNT2J) MBR(EVNT2J)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNT2L1) MBR(EVNT2L1)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNT2L2) MBR(EVNT2L2)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNT3J) MBR(EVNT3J)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNT3L1) MBR(EVNT3L1)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   RMVM       FILE(EVNT3L2) MBR(EVNT3L2)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/**                                                            S01117*/
/**/                                                                  /*CDL008*/
/* Check if switchable feature CDL008 is on (CLS)                     /*CDL008*/
/**/                                                                  /*CDL008*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CDL008*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CDL008*/
             CHGVAR     VAR(&SAR) VALUE('CDL008')                     /*CDL008*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CDL008*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CDL008) VALUE('Y'))                      /*CDL008*/
/**/                                                                  /*CDL008*/
             CLRPFM     FILE(EVNTXEC)
             CLRPFM     FILE(EVNTXED)
             CLRPFM     FILE(EVNTXZZ)
              IF         COND(&CGL187 *EQ 'Y') THEN(CLRPFM +
              FILE(EVNTXEX0))                                                             /*CGL187*/
/*/COPY WNCPYSRC,DLC0607001                                          */
/**/
/*IF EXPOSURE MANAGEMENT MODULE PRESENT CLEAR EM FILES AND SET ON */
/*  SWITCH 1 TO CONDITION OUTPUT   */
/**/
             IF         COND(%SST(&MMOD 7 1)='Y') THEN(DO)
             CLRPFM     FILE(EMXT2H1)
             CLRPFM     FILE(EMXT2D2)
             CLRPFM     FILE(EMXT2T1)
             CLRPFM     FILE(EMTE2H1)
             CLRPFM     FILE(EMTE2E2)
             CLRPFM     FILE(EMTE2T1)
/*/COPY WNCPYSRC,DLC0607004                                          */
/**/
             CHGJOB     SWS(1XXXXXXX)
             ENDDO
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABDLEI)                   /*S01194*/
             OVRDBF     FILE(EVNTXED) SEQONLY(*YES 100)               /*S01095*/
             OVRDBF     FILE(EMXT2D2) SEQONLY(*YES 50)                /*S01095*/
             OVRDBF     FILE(EMTE2E2) SEQONLY(*YES 50)                /*S01095*/
             CALL       PGM(DL0400)
             RTVJOBA    SWS(&SWS)
/**/                                                                  /*CDL008*/
/* Call DL0404 if switchable feature CDL008 is installed              /*CDL008*/
/**/                                                                  /*CDL008*/
             IF         COND(%SUBSTRING(&SWS 7 2) = '00') THEN(DO)    /*CDL008*/
                 IF        COND(&CDL008 = 'Y') THEN(CALL DL0404)      /*CDL008*/
             ENDDO                                                    /*CDL008*/
/*********** DLTOVR     FILE(TABLE)                                   /*S01194*/
             DLTOVR     FILE(EVNTXED)                                 /*S01095*/
             DLTOVR     FILE(EMXT2D2)                                 /*S01095*/
             DLTOVR     FILE(EMTE2E2)                                 /*S01095*/
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) = '11') THEN(SNDMSG +
                        MSG('Job Terminated - database in error') +
                        TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) = '01') THEN(SNDMSG +
                        MSG('File controls out of balance') TOMSGQ(MOPERQ))
/**/
/*SWITCH OFF EM SWITCH 1           */
/**/
             IF         COND(%SST(&MMOD 7 1) = 'Y') THEN(CHGJOB +
                          SWS(0XXXXXXX))
/*********   ADDLFM       FILE(EVENT) MBR(EVENT)                    /*E20*/
/*********   MONMSG     MSGID(CPF0000)                              /*E20*/
/*********   ADDLFM       FILE(EVNT1) MBR(EVNT1)                    /*E20*/
/*********   MONMSG     MSGID(CPF0000)                              /*E20*/
/*********   ADDLFM       FILE(EVNT2) MBR(EVNT2)                    /*E20*/
/*********   MONMSG     MSGID(CPF0000)                              /*E20*/
/*********   ADDLFM       FILE(EVNT3) MBR(EVNT3)                    /*E20*/
/*********   MONMSG     MSGID(CPF0000)                              /*E20*/
/*********   ADDLFM       FILE(EVNTM) MBR(EVNTM)                    /*E20*/
/*********   MONMSG     MSGID(CPF0000)                              /*E20*/
/*********   ADDLFM       FILE(EVNTD) MBR(EVNTD)                    /*E20*/
/*********   MONMSG     MSGID(CPF0000)                              /*E20*/
/*********   ADDLFM       FILE(EVLSC) MBR(EVLSC)                    /*E20*/
/*********   MONMSG     MSGID(CPF0000)                              /*E20*/
/*********   ADDLFM       FILE(EVLSR) MBR(EVLSR)                    /*E20*/
/*********   MONMSG     MSGID(CPF0000)                              /*E20*/
/*********   ADDLFM       FILE(EVLSX) MBR(EVLSX)                    /*E20*/
/*********   MONMSG     MSGID(CPF0000)                              /*E20*/
/**                                                            S01117*/
/**   ADDLFM TO REBUILD FILES BUILT OVER EVNTXED               S01117*/
/**                                                            S01117*/
/*********   ADDLFM       FILE(ACCEXAN) MBR(ACCEXAN)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVENTA) MBR(EVENTA)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVDLS) MBR(EVDLS)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVDLSL1) MBR(EVDLSL1)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVENT2) MBR(EVENT2)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVENT3) MBR(EVENT3)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVFXS) MBR(EVFXS)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVFXSL1) MBR(EVFXSL1)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLACB) MBR(EVLACB)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLACO) MBR(EVLACO)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLBBA) MBR(EVLBBA)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLBBN) MBR(EVLBBN)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLBBP) MBR(EVLBBP)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLBBR) MBR(EVLBBR)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLCBA) MBR(EVLCBA)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLCBN) MBR(EVLCBN)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLCBP) MBR(EVLCBP)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLCBR) MBR(EVLCBR)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLCOA) MBR(EVLCOA)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLCON) MBR(EVLCON)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLCOP) MBR(EVLCOP)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLCOR) MBR(EVLCOR)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLNCB) MBR(EVLNCB)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLNCO) MBR(EVLNCO)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLOBA) MBR(EVLOBA)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLOBN) MBR(EVLOBN)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLOBP) MBR(EVLOBP)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLOBR) MBR(EVLOBR)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLPCB) MBR(EVLPCB)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLPCO) MBR(EVLPCO)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLRCB) MBR(EVLRCB)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVLRCO) MBR(EVLRCO)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNTJL1) MBR(EVNTJL1)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNTL2) MBR(EVNTL2)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNTL5) MBR(EVNTL5)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNTML1) MBR(EVNTML1)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNTML1) MBR(EVNTML1)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNTML1) MBR(EVNTML1)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNTML2) MBR(EVNTML2)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNTML3) MBR(EVNTML3)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNTML4) MBR(EVNTML4)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNTML5) MBR(EVNTML5)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNTML6) MBR(EVNTML6)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNTP) MBR(EVNTP)             /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNT1J) MBR(EVNT1J)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNT1L1) MBR(EVNT1L1)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNT1L1R) MBR(EVNT1L1R)       /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNT1L2) MBR(EVNT1L2)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNT1L2R) MBR(EVNT1L2R)       /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNT1R) MBR(EVNT1R)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNT2J) MBR(EVNT2J)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNT2L1) MBR(EVNT2L1)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNT2L2) MBR(EVNT2L2)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNT3J) MBR(EVNT3J)           /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNT3L1) MBR(EVNT3L1)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/*********   ADDLFM       FILE(EVNT3L2) MBR(EVNT3L2)         /*S01117*E20*/
/*********   MONMSG     MSGID(CPF0000)                       /*S01117*E20*/
/**                                                            S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
