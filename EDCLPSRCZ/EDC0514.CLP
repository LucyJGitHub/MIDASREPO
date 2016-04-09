/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ED Copy of MKEYDP')                             */
/********************************************************************/
/*                                                                  */
/*       Midas - Export Data Interface Module                       */
/*                                                                  */
/*       EDC0514 -  Copy of MKEYDP                                  */
/*                                                                  */
/*       Function : This program copies selected a/c key records    */
/*                  from MKEYDP to the ED Extract file EDMKEYPD.    */
/*                  A/c key records are copied if they match one    */
/*                  of the a/c key 'Skeletons' in EDMKYRPD.         */
/*                                                                  */
/*       Called By: CBC0050  Midas Close of Business component      */
/*                                                                  */
/*       Calls :    *None                                           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CED006 *CREATE     DATE 24JUL97             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CED006 - Midas ED Enhancements                             */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&CNAM &CSEQ &MBRN)
 
/* Copyright statement definition */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&MBRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
 
/* Global error monitor */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/* Call AOBUTFR0 to check file EDMKEYPD selected for transfer to GM */
 
             CALL       PGM(AOBUTFR0) PARM('EDMKEYPD' '          ' +
                          &RTCD &FMT)
 
/* EDMKEYPD is selected for transfer */
 
             IF         COND(&RTCD *NE '*FAILED') THEN(DO)
 
/* Select matching a/c key records */
             OPNQRYF    FILE((MKEYDP) (EDMKYRPD) (SDLOANPD) +
                          (SDBANKPD)) FORMAT(EDMKEYPD EDMKEYD0) +
                          JFLD((AKEYE10 AKEYR10 *EQ) (AKEYE1 +
                          AYLNTY) (AKEYE4 AYLNST)) GRPFLD(LNNO AKEY +
                          EDAT REVI) MAPFLD((AKEYE10 +
                          '%SST(MKEYDP/AKEY 10 1)') (AKEYR10 +
                          '%SST(EDMKYRPD/FYAKEY 10 1)') (AKEYE1 +
                          '%SST(MKEYDP/AKEY 1 2)') (AKEYE4 +
                          '%SST(MKEYDP/AKEY 4 2)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(MKEYDP/RECI)') (CNUM +
                          '%MIN(MKEYDP/CNUM)') (BRCA +
                          '%MIN(MKEYDP/BRCA)') (ACSQ +
                          '%MIN(MKEYDP/ACSQ)') (EAMT +
                          '%SUM(MKEYDP/EAMT)') (ECCY +
                          '%MIN(MKEYDP/ECCY)') (SETP +
                          '%MIN(MKEYDP/SETP)') (OSAC +
                          '%MIN(MKEYDP/OSAC)') (OTHA +
                          '%SUM(MKEYDP/OTHA)') (OTHC +
                          '%MIN(MKEYDP/OTHC)') (EXRT +
                          '%MIN(MKEYDP/EXRT)') (STDT +
                          '%MIN(MKEYDP/STDT)') (SLID +
                          '%MIN(MKEYDP/SLID)') (MDAT +
                          '%MIN(MKEYDP/MDAT)') (BRTT +
                          '%MIN(MKEYDP/BRTT)') (BRTE +
                          '%MIN(MKEYDP/BRTE)') (RTSP +
                          '%MIN(MKEYDP/RTSP)') (INTR +
                          '%MIN(MKEYDP/INTR)') (SSEQ +
                          '%MIN(MKEYDP/SSEQ)') (CPAM +
                          '%MIN(MKEYDP/CPAM)') (PACD +
                          '%MIN(MKEYDP/PACD)') (ICBS +
                          '%MIN(MKEYDP/ICBS)') (ACOF +
                          '%MIN(MKEYDP/ACOF)') (ZZ002 +
                          '%MIN(MKEYDP/ZZ002)') (FACO +
                          '%MIN(MKEYDP/FACO)') (PRFC +
                          '%MIN(MKEYDP/PRFC)') (OSBR +
                          '%MIN(MKEYDP/OSBR)') (BOKC +
                          '%MIN(MKEYDP/BOKC)') (PELAP +
                          '%MIN(MKEYDP/PELAP)') (ORED +
                          '%MIN(MKEYDP/ORED)') (OLNO +
                          '%MIN(MKEYDP/OLNO)') (PTFR +
                          '%MIN(MKEYDP/PTFR)') (AYLNPT +
                          '%MIN(SDLOANPD/AYLNPT)')) OPNID(EDMKEYPD)
 
 
             CPYFRMQRYF FROMOPNID(EDMKEYPD) TOFILE(EDMKEYPD) +
                          TOMBR(&MBRN) MBROPT(*REPLACE) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDMKEYPD)
             ENDDO
 
/* Normal termination */
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(ENDCLPGM))
 
/* Abnormal termination */
ABNOR:
 
             SNDPGMMSG  MSG('EDC0514 - ED Copy of MKEYDP TERMINATED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGJOB     SWS(XXXXXX11)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
