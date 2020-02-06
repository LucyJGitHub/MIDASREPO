/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ED Copy of LKEY1DP')                            */
/********************************************************************/
/*                                                                  */
/*       Midas - Export Data Interface Module                       */
/*                                                                  */
/*       EDC0512 -  Copy of LKEY1DP                                 */
/*                                                                  */
/*       Function : This program copies selected a/c key records    */
/*                  from LKEY1DP to the ED Extract file EDLKY1PD.   */
/*                  A/c key records are copied if they match one    */
/*                  of the a/c key 'Skeletons' in EDLKYRPD.         */
/*                                                                  */
/*       Called By: CBC0050  Midas Close of Business component      */
/*                                                                  */
/*       Calls :    *None                                           */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CED006 *C *CREATE  Date 23Jul97              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CED006 - Midas ED Enhancements                             */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&CNAM &CSEQ &MBRN)
 
/* Copyright statement definition */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
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
 
/* Call AOBUTFR0 to check file EDDKEYPD selected for transfer to GM */
 
             CALL       PGM(AOBUTFR0) PARM('EDLKY1PD' '         ' +
                          &RTCD &FMT)
 
/* EDLKY1PD is selected for transfer */
 
             IF         COND(&RTCD *NE '*FAILED') THEN(DO)
 
/* Select matching a/c key records */
             OPNQRYF    FILE((LKEY1DP) (EDLKYRPD) (SDLOANPD) +
                          (SDBANKPD)) FORMAT(EDLKY1PD EDLKY1D0) +
                          JFLD((AKEYE3 AKEYR3 *EQ) (AKEYE6 AKEYR6) +
                          (AKEYE7 AKEYR7) (AKEYE8 AKEYR8) (AKEYE9 +
                          AKEYR9) (AKEYE10 AKEYR10) (AKEYE1 AYLNTY) +
                          (AKEYE4 AYLNST)) GRPFLD(LNNO AKEY EDAT +
                          REVI) MAPFLD((AKEYE3 '%SST(LKEY1DP/AKEY 3 +
                          1)') (AKEYR3 '%SST(EDLKYRPD/FYAKEY 3 1)') +
                          (AKEYE6 '%SST(LKEY1DP/AKEY 6 1)') (AKEYR6 +
                          '%SST(EDLKYRPD/FYAKEY 6 1)') (AKEYE7 +
                          '%SST(LKEY1DP/AKEY 7 1)') (AKEYR7 +
                          '%SST(EDLKYRPD/FYAKEY 7 1)') (AKEYE8 +
                          '%SST(LKEY1DP/AKEY 8 1)') (AKEYR8 +
                          '%SST(EDLKYRPD/FYAKEY 8 1)') (AKEYE9 +
                          '%SST(LKEY1DP/AKEY 9 1)') (AKEYR9 +
                          '%SST(EDLKYRPD/FYAKEY 9 1)') (AKEYE10 +
                          '%SST(LKEY1DP/AKEY 10 1)') (AKEYR10 +
                          '%SST(EDLKYRPD/FYAKEY 10 1)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (AKEYE1 +
                          '%SST(LKEY1DP/AKEY 1 2)') (AKEYE4 +
                          '%SST(LKEY1DP/AKEY 4 2)') (RECI +
                          '%MIN(LKEY1DP/RECI)') (CNUM +
                          '%MIN(LKEY1DP/CNUM)') (BRCA +
                          '%MIN(LKEY1DP/BRCA)') (ACSQ +
                          '%MIN(LKEY1DP/ACSQ)') (EAMT +
                          '%SUM(LKEY1DP/EAMT)') (ECCY +
                          '%MIN(LKEY1DP/ECCY)') (SETP +
                          '%MIN(LKEY1DP/SETP)') (OSAC +
                          '%MIN(LKEY1DP/OSAC)') (OTHA +
                          '%SUM(LKEY1DP/OTHA)') (OTHC +
                          '%MIN(LKEY1DP/OTHC)') (EXRT +
                          '%MIN(LKEY1DP/EXRT)') (STDT +
                          '%MIN(LKEY1DP/STDT)') (SLID +
                          '%MIN(LKEY1DP/SLID)') (MDAT +
                          '%MIN(LKEY1DP/MDAT)') (BRTT +
                          '%MIN(LKEY1DP/BRTT)') (BRTE +
                          '%MIN(LKEY1DP/BRTE)') (RTSP +
                          '%MIN(LKEY1DP/RTSP)') (INTR +
                          '%MIN(LKEY1DP/INTR)') (SSEQ +
                          '%MIN(LKEY1DP/SSEQ)') (CPAM +
                          '%MIN(LKEY1DP/CPAM)') (PACD +
                          '%MIN(LKEY1DP/PACD)') (ICBS +
                          '%MIN(LKEY1DP/ICBS)') (ACOF +
                          '%MIN(LKEY1DP/ACOF)') (ZZ002 +
                          '%MIN(LKEY1DP/ZZ002)') (FACO +
                          '%MIN(LKEY1DP/FACO)') (PRFC +
                          '%MIN(LKEY1DP/PRFC)') (OSBR +
                          '%MIN(LKEY1DP/OSBR)') (BOKC +
                          '%MIN(LKEY1DP/BOKC)') (PELAP +
                          '%MIN(LKEY1DP/PELAP)') (ORED +
                          '%MIN(LKEY1DP/ORED)') (OLNO +
                          '%MIN(LKEY1DP/OLNO)') (PTFR +
                          '%MIN(LKEY1DP/PTFR)') (AYLNPT +
                          '%MIN(SDLOANPD/AYLNPT)')) OPNID(EDLKY1PD)
 
 
             CPYFRMQRYF FROMOPNID(EDLKY1PD) TOFILE(EDLKY1PD) +
                          TOMBR(&MBRN) MBROPT(*REPLACE) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDLKY1PD)
             ENDDO
 
/* Normal termination */
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(ENDCLPGM))
 
 
/* Abnormal termination */
ABNOR:
 
             SNDPGMMSG  MSG('EDC0512 - ED Copy of LKEY1DP TERMINATED +
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
                          Finastra International Limited')
 
             ENDPGM
