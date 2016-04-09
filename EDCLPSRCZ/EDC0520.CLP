/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Copy of FOKEYD')                             */
/********************************************************************/
/*                                                                  */
/*       Midas - Export Data Interface Module                       */
/*                                                                  */
/*       EDC0520 -  Copy of FOKEYD                                  */
/*                                                                  */
/*       Function : This program copies selected a/c key records    */
/*                  from FOKEYD to the member of ED Extract file    */
/*                  EDFKEYPD. A/c key records are copied if they    */
/*                  match one of the a/c key 'Skeletons' in         */
/*                  EDFOKRPD.                                       */
/*                                                                  */
/*       Called By: CBC0050  Midas Close of Business component      */
/*                                                                  */
/*       Calls :    *None                                           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 124612             DATE 20OCT97             */
/*       PREV AMEND NO. CED006 *CREATE     DATE 31JUL97             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       124612 - FO A/C keys not copied                            */
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
             DCL        VAR(&A) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(256)
/*           DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)                  /*124612*/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(10) VALUE('OTC')    /*124612*/
 
/* Global error monitor */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/* Call AOBUTFR0 to check file EDFKEYPD selected for transfer to GM */
 
             CALL       PGM(AOBUTFR0) PARM('EDFKEYPD' '          ' +
                          &RTCD &FMT)
 
/* FOKEYD is selected for transfer */
 
             IF         COND(&RTCD *NE '*FAILED') THEN(DO)
 
/* Monitor for member not found */
/* If member not found - new market centre   */
             CLRPFM     FILE(EDFKEYPD) MBR(&MBRN)
             MONMSG     MSGID(CPF3141)
 
/* Member = Start. Copy records from EDSFKYPD produced in FFC1080. */
               IF         COND(&MBRN *EQ 'START') THEN(DO)
               CPYF       FROMFILE(EDSFKYPD) TOFILE(EDFKEYPD) +
                          FROMMBR(*ALL) TOMBR(&MBRN) MBROPT(*ADD)
               MONMSG     MSGID(CPF2817)
               ENDDO
 
               ELSE       CMD(DO)
/* Member = COB */
                 IF         COND(&MBRN *EQ 'COB') THEN(DO)
                 RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)
 
/* Every market centre in FFEOC processed */
LOOP:
/*                 IF         COND((%SST(&FFEOC &A 2) *EQ '  ')  +    /*124612*/
/*                      *OR (&A *GT 61)) THEN(GOTO CMDLBL(NEXT))      /*124612*/
/*                 CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))      /*124612*/
/*                 CHGVAR     VAR(&A) VALUE(&A + 2)                   /*124612*/
 
/* Select matching a/c key records */
             OPNQRYF    FILE((FOKEYD &MKT) (EDFOKRPD) (SDBANKPD)) +
                          FORMAT(EDFKEYPD EDFKEYD0) JFLD((AKEYE1 +
                          AKEYR1 *EQ) (AKEYE11 AKEYR11)) +
                          GRPFLD(TNBR FFKY EDAT REVI) +
                          MAPFLD((AKEYE1 '%SST(FOKEYD/FFKY 1 3)') +
                          (AKEYR1 '%SST(EDFOKRPD/FYFFKY 1 3)') +
                          (AKEYE11 '%SST(FOKEYD/FFKY 11 4)') +
                          (AKEYR11 '%SST(EDFOKRPD/FYFFKY 11 4)') +
                          (AGRDNB '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(FOKEYD/RECI)') (CLON +
                          '%MIN(FOKEYD/CLON)') (CBCD +
                          '%MIN(FOKEYD/CBCD)') (BOKC +
                          '%MIN(FOKEYD/BOKC)') (BRCA +
                          '%MIN(FOKEYD/BRCA)') (OBKC +
                          '%MIN(FOKEYD/OBKC)') (ASEQ +
                          '%MIN(FOKEYD/ASEQ)') (EAMT +
                          '%SUM(FOKEYD/EAMT)') (CCY +
                          '%MIN(FOKEYD/CCY)') (VDAT +
                          '%MIN(FOKEYD/VDAT)') (SETP +
                          '%MIN(FOKEYD/SETP)') (SETA +
                          '%MIN(FOKEYD/SETA)') (SEBR +
                          '%MIN(FOKEYD/SEBR)') (ISTT +
                          '%MIN(FOKEYD/ISTT)') (YRNO +
                          '%MIN(FOKEYD/YRNO)') (MTHN +
                          '%MIN(FOKEYD/MTHN)') (PCAL +
                          '%MIN(FOKEYD/PCAL)') (STRP +
                          '%MIN(FOKEYD/STRP)') (ISTN +
                          '%MIN(FOKEYD/ISTN)') (PRFC +
                          '%MIN(FOKEYD/PRFC)') (PTFR +
                          '%MIN(FOKEYD/PTFR)')) OPNID(EDFKEYPD)
 
                   CPYFRMQRYF FROMOPNID(EDFKEYPD) TOFILE(EDFKEYPD) +
                          TOMBR(&MBRN) MBROPT(*ADD) FMTOPT(*NOCHK)
 
/* Close */
                   CLOF       OPNID(EDFKEYPD)
                   IF         COND((%SST(&FFEOC &A 2) *EQ '  ')  +
                        *OR (&A *GT 61)) THEN(GOTO CMDLBL(NEXT))      /*124612*/
                   CHGVAR     VAR(&MKT) VALUE(' ')                    /*124612*/
                   CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))      /*124612*/
                   CHGVAR     VAR(&A) VALUE(&A + 2)                   /*124612*/
                   GOTO       CMDLBL(LOOP)
                 ENDDO
 
/* Member not Start or COB */
                 ELSE       CMD(DO)
 
/* Select matching a/c key records */
             OPNQRYF    FILE((FOKEYD *FIRST) (EDFOKRPD) (SDBANKPD)) +
                          FORMAT(EDFKEYPD EDFKEYD0) JFLD((AKEYE1 +
                          AKEYR1 *EQ) (AKEYE11 AKEYR11)) +
                          GRPFLD(TNBR FFKY EDAT REVI) +
                          MAPFLD((AKEYE1 '%SST(FOKEYD/FFKY 1 3)') +
                          (AKEYR1 '%SST(EDFOKRPD/FYFFKY 1 3)') +
                          (AKEYE11 '%SST(FOKEYD/FFKY 11 4)') +
                          (AKEYR11 '%SST(EDFOKRPD/FYFFKY 11 4)') +
                          (AGRDNB '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(FOKEYD/RECI)') (CLON +
                          '%MIN(FOKEYD/CLON)') (CBCD +
                          '%MIN(FOKEYD/CBCD)') (BOKC +
                          '%MIN(FOKEYD/BOKC)') (BRCA +
                          '%MIN(FOKEYD/BRCA)') (OBKC +
                          '%MIN(FOKEYD/OBKC)') (ASEQ +
                          '%MIN(FOKEYD/ASEQ)') (EAMT +
                          '%SUM(FOKEYD/EAMT)') (CCY +
                          '%MIN(FOKEYD/CCY)') (VDAT +
                          '%MIN(FOKEYD/VDAT)') (SETP +
                          '%MIN(FOKEYD/SETP)') (SETA +
                          '%MIN(FOKEYD/SETA)') (SEBR +
                          '%MIN(FOKEYD/SEBR)') (ISTT +
                          '%MIN(FOKEYD/ISTT)') (YRNO +
                          '%MIN(FOKEYD/YRNO)') (MTHN +
                          '%MIN(FOKEYD/MTHN)') (PCAL +
                          '%MIN(FOKEYD/PCAL)') (STRP +
                          '%MIN(FOKEYD/STRP)') (ISTN +
                          '%MIN(FOKEYD/ISTN)') (PRFC +
                          '%MIN(FOKEYD/PRFC)') (PTFR +
                          '%MIN(FOKEYD/PTFR)')) OPNID(EDFKEYPD)
 
                 CPYFRMQRYF FROMOPNID(EDFKEYPD) TOFILE(EDFKEYPD) +
                          TOMBR(&MBRN) MBROPT(*ADD) FMTOPT(*NOCHK)
 
/* Close */
                 CLOF       OPNID(EDFKEYPD)
                 ENDDO
               ENDDO
             ENDDO
 
/* Normal termination */
NEXT:
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(ENDCLPGM))
 
/* Abnormal termination */
ABNOR:
 
             SNDPGMMSG  MSG('EDC0520 - ED Copy of FOKEYD TERMINATED +
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
