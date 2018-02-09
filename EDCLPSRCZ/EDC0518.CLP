/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Copy of SEKEYD')                             */
/********************************************************************/
/*                                                                  */
/*       Midas - Export Data Interface Module                       */
/*                                                                  */
/*       EDC0518 -  Copy of SEKEYD                                  */
/*                                                                  */
/*       Function : This program copies selected a/c key records    */
/*                  from SEKEYD to the ED Extract file EDSKEYPD.    */
/*                  A/c key records are copied if they match one    */
/*                  of the a/c key 'Skeletons' in EDSKYRPD.         */
/*                                                                  */
/*       Called By: CBC0050  Midas Close of Business component      */
/*                                                                  */
/*       Calls :    *None                                           */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. CED006 *CREATE     DATE 23JUL97             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
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
 
/* Call AOBUTFR0 to check file EDLFEEPD selected for transfer to GM */
 
             CALL       PGM(AOBUTFR0) PARM('EDSKEYPD' '          ' +
                          &RTCD &FMT)
 
/* EDSKEYPD is selected for transfer */
 
             IF         COND(&RTCD *NE '*FAILED') THEN(DO)
 
/* Select matching a/c key records */
/* Member ACCRUAL on file SEKEYD */
/* Exclusion of C__bb_____DI and H__bb_____DI keys and inclusion of */
/* C__BB_____DI and H__BB_____DI keys catered for in EDSKYRPD  */
 
             OPNQRYF    FILE((SEKEYD ACCRUAL) (EDSKYRPD) (SDBANKPD)) +
                          FORMAT(EDSKEYPD EDSKEYD0) JFLD((AKEYE4 +
                          AKEYR4 *EQ) (AKEYE9 AKEYR9) (AKEYE13 +
                          AKEYR13) (AKEYE19 AKEYR19)) GRPFLD(ACKY +
                          TRFR EVDT RVRS) MAPFLD((AKEYE4 +
                          '%SST(SEKEYD/ACKY 4 3)') (AKEYR4 +
                          '%SST(EDSKYRPD/FYACKE 4 3)') (AKEYE9 +
                          '%SST(SEKEYD/ACKY 9 2)') (AKEYR9 +
                          '%SST(EDSKYRPD/FYACKE 9 2)') (AKEYE13 +
                          '%SST(SEKEYD/ACKY 13 3)') (AKEYR13 +
                          '%SST(EDSKYRPD/FYACKE 13 3)') (AKEYE19 +
                          '%SST(SEKEYD/ACKY 19 2)') (AKEYR19 +
                          '%SST(EDSKYRPD/FYACKE 19 2)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(SEKEYD/RECI)') (CSTN +
                          '%MIN(SEKEYD/CSTN)') (BRHA +
                          '%MIN(SEKEYD/BRHA)') (ASQN +
                          '%MIN(SEKEYD/ASQN)') (EVAM +
                          '%SUM(SEKEYD/EVAM)') (EVCY +
                          '%MIN(SEKEYD/EVCY)') (STLT +
                          '%MIN(SEKEYD/STLT)') (STLA +
                          '%MIN(SEKEYD/STLA)') (SEBR +
                          '%MIN(SEKEYD/SEBR)') (ISSR +
                          '%MIN(SEKEYD/ISSR)') (KCUST +
                          '%MIN(SEKEYD/KCUST)') (KNCA +
                          '%SUM(SEKEYD/KNCA)') (KCCY +
                          '%MIN(SEKEYD/KCCY)') (KBCA +
                          '%SUM(SEKEYD/KBCA)') (SESH +
                          '%MIN(SEKEYD/SESH)') (PRFC +
                          '%MIN(SEKEYD/PRFC)') (PTFR +
                          '%MIN(SEKEYD/PTFR)') (TNLU +
                          '%MIN(SEKEYD/TNLU)') (PEV1 +
                          '%MIN(SEKEYD/PEV1)')) OPNID(EDSKEY01)
 
             CPYFRMQRYF FROMOPNID(EDSKEY01) TOFILE(EDSKEYPD) +
                          TOMBR(&MBRN) MBROPT(*REPLACE) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDSKEY01)
 
/* Select matching a/c key records */
/* Member BKMATUR on file SEKEYD */
/* Exclusion of C__bb_____DI and H__bb_____DI keys and inclusion of */
/* C__BB_____DI and H__BB_____DI keys catered for in EDSKYRPD  */
 
             OPNQRYF    FILE((SEKEYD BKMATUR) (EDSKYRPD) (SDBANKPD)) +
                          FORMAT(EDSKEYPD EDSKEYD0) JFLD((AKEYE4 +
                          AKEYR4 *EQ) (AKEYE9 AKEYR9) (AKEYE13 +
                          AKEYR13) (AKEYE19 AKEYR19)) +
                          GRPFLD(ACKY TRFR EVDT RVRS) +
                          MAPFLD((AKEYE4 '%SST(SEKEYD/ACKY 4 3)') +
                          (AKEYR4 '%SST(EDSKYRPD/FYACKE 4 3)') +
                          (AKEYE9 '%SST(SEKEYD/ACKY 9 2)') (AKEYR9 +
                          '%SST(EDSKYRPD/FYACKE 9 2)') (AKEYE13 +
                          '%SST(SEKEYD/ACKY 13 3)') (AKEYR13 +
                          '%SST(EDSKYRPD/FYACKE 13 3)') (AKEYE19 +
                          '%SST(SEKEYD/ACKY 19 2)') (AKEYR19 +
                          '%SST(EDSKYRPD/FYACKE 19 2)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(SEKEYD/RECI)') (CSTN +
                          '%MIN(SEKEYD/CSTN)') (BRHA +
                          '%MIN(SEKEYD/BRHA)') (ASQN +
                          '%MIN(SEKEYD/ASQN)') (EVAM +
                          '%SUM(SEKEYD/EVAM)') (EVCY +
                          '%MIN(SEKEYD/EVCY)') (STLT +
                          '%MIN(SEKEYD/STLT)') (STLA +
                          '%MIN(SEKEYD/STLA)') (SEBR +
                          '%MIN(SEKEYD/SEBR)') (ISSR +
                          '%MIN(SEKEYD/ISSR)') (KCUST +
                          '%MIN(SEKEYD/KCUST)') (KNCA +
                          '%SUM(SEKEYD/KNCA)') (KCCY +
                          '%MIN(SEKEYD/KCCY)') (KBCA +
                          '%SUM(SEKEYD/KBCA)') (SESH +
                          '%MIN(SEKEYD/SESH)') (PRFC +
                          '%MIN(SEKEYD/PRFC)') (PTFR +
                          '%MIN(SEKEYD/PTFR)') (TNLU +
                          '%MIN(SEKEYD/TNLU)') (PEV1 +
                          '%MIN(SEKEYD/PEV1)')) OPNID(EDSKEY02)
 
             CPYFRMQRYF FROMOPNID(EDSKEY02) TOFILE(EDSKEYPD) +
                          TOMBR(&MBRN) MBROPT(*ADD) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDSKEY02)
 
/* Select matching a/c key records */
/* Member BKPOSN on file SEKEYD */
/* Exclusion of C__bb_____DI and H__bb_____DI keys and inclusion of */
/* C__BB_____DI and H__BB_____DI keys catered for in EDSKYRPD  */
 
             OPNQRYF    FILE((SEKEYD BKPOSN) (EDSKYRPD) (SDBANKPD)) +
                          FORMAT(EDSKEYPD EDSKEYD0) JFLD((AKEYE4 +
                          AKEYR4 *EQ) (AKEYE9 AKEYR9) (AKEYE13 +
                          AKEYR13) (AKEYE19 AKEYR19)) +
                          GRPFLD(ACKY TRFR EVDT RVRS) +
                          MAPFLD((AKEYE4 '%SST(SEKEYD/ACKY 4 3)') +
                          (AKEYR4 '%SST(EDSKYRPD/FYACKE 4 3)') +
                          (AKEYE9 '%SST(SEKEYD/ACKY 9 2)') (AKEYR9 +
                          '%SST(EDSKYRPD/FYACKE 9 2)') (AKEYE13 +
                          '%SST(SEKEYD/ACKY 13 3)') (AKEYR13 +
                          '%SST(EDSKYRPD/FYACKE 13 3)') (AKEYE19 +
                          '%SST(SEKEYD/ACKY 19 2)') (AKEYR19 +
                          '%SST(EDSKYRPD/FYACKE 19 2)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(SEKEYD/RECI)') (CSTN +
                          '%MIN(SEKEYD/CSTN)') (BRHA +
                          '%MIN(SEKEYD/BRHA)') (ASQN +
                          '%MIN(SEKEYD/ASQN)') (EVAM +
                          '%SUM(SEKEYD/EVAM)') (EVCY +
                          '%MIN(SEKEYD/EVCY)') (STLT +
                          '%MIN(SEKEYD/STLT)') (STLA +
                          '%MIN(SEKEYD/STLA)') (SEBR +
                          '%MIN(SEKEYD/SEBR)') (ISSR +
                          '%MIN(SEKEYD/ISSR)') (KCUST +
                          '%MIN(SEKEYD/KCUST)') (KNCA +
                          '%SUM(SEKEYD/KNCA)') (KCCY +
                          '%MIN(SEKEYD/KCCY)') (KBCA +
                          '%SUM(SEKEYD/KBCA)') (SESH +
                          '%MIN(SEKEYD/SESH)') (PRFC +
                          '%MIN(SEKEYD/PRFC)') (PTFR +
                          '%MIN(SEKEYD/PTFR)') (TNLU +
                          '%MIN(SEKEYD/TNLU)') (PEV1 +
                          '%MIN(SEKEYD/PEV1)')) OPNID(EDSKEY03)
 
             CPYFRMQRYF FROMOPNID(EDSKEY03) TOFILE(EDSKEYPD) +
                          TOMBR(&MBRN) MBROPT(*ADD) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDSKEY03)
 
/* Select matching a/c key records */
/* Member BKPOSNR on file SEKEYD */
/* Exclusion of C__bb_____DI and H__bb_____DI keys and inclusion of */
/* C__BB_____DI and H__BB_____DI keys catered for in EDSKYRPD  */
 
             OPNQRYF    FILE((SEKEYD BKPOSNR) (EDSKYRPD) (SDBANKPD)) +
                          FORMAT(EDSKEYPD EDSKEYD0) JFLD((AKEYE4 +
                          AKEYR4 *EQ) (AKEYE9 AKEYR9) (AKEYE13 +
                          AKEYR13) (AKEYE19 AKEYR19)) +
                          GRPFLD(ACKY TRFR EVDT RVRS) +
                          MAPFLD((AKEYE4 '%SST(SEKEYD/ACKY 4 3)') +
                          (AKEYR4 '%SST(EDSKYRPD/FYACKE 4 3)') +
                          (AKEYE9 '%SST(SEKEYD/ACKY 9 2)') (AKEYR9 +
                          '%SST(EDSKYRPD/FYACKE 9 2)') (AKEYE13 +
                          '%SST(SEKEYD/ACKY 13 3)') (AKEYR13 +
                          '%SST(EDSKYRPD/FYACKE 13 3)') (AKEYE19 +
                          '%SST(SEKEYD/ACKY 19 2)') (AKEYR19 +
                          '%SST(EDSKYRPD/FYACKE 19 2)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(SEKEYD/RECI)') (CSTN +
                          '%MIN(SEKEYD/CSTN)') (BRHA +
                          '%MIN(SEKEYD/BRHA)') (ASQN +
                          '%MIN(SEKEYD/ASQN)') (EVAM +
                          '%SUM(SEKEYD/EVAM)') (EVCY +
                          '%MIN(SEKEYD/EVCY)') (STLT +
                          '%MIN(SEKEYD/STLT)') (STLA +
                          '%MIN(SEKEYD/STLA)') (SEBR +
                          '%MIN(SEKEYD/SEBR)') (ISSR +
                          '%MIN(SEKEYD/ISSR)') (KCUST +
                          '%MIN(SEKEYD/KCUST)') (KNCA +
                          '%SUM(SEKEYD/KNCA)') (KCCY +
                          '%MIN(SEKEYD/KCCY)') (KBCA +
                          '%SUM(SEKEYD/KBCA)') (SESH +
                          '%MIN(SEKEYD/SESH)') (PRFC +
                          '%MIN(SEKEYD/PRFC)') (PTFR +
                          '%MIN(SEKEYD/PTFR)') (TNLU +
                          '%MIN(SEKEYD/TNLU)') (PEV1 +
                          '%MIN(SEKEYD/PEV1)')) OPNID(EDSKEY04)
 
             CPYFRMQRYF FROMOPNID(EDSKEY04) TOFILE(EDSKEYPD) +
                          TOMBR(&MBRN) MBROPT(*ADD) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDSKEY04)
 
/* Select matching a/c key records */
/* Member CONTLIAB on file SEKEYD */
/* Exclusion of C__bb_____DI and H__bb_____DI keys and inclusion of */
/* C__BB_____DI and H__BB_____DI keys catered for in EDSKYRPD  */
 
             OPNQRYF    FILE((SEKEYD CONTLIAB) (EDSKYRPD) +
                          (SDBANKPD)) FORMAT(EDSKEYPD EDSKEYD0) +
                          JFLD((AKEYE4 AKEYR4 *EQ) (AKEYE9 AKEYR9) +
                          (AKEYE13 AKEYR13) (AKEYE19 AKEYR19)) +
                          GRPFLD(ACKY TRFR EVDT RVRS) +
                          MAPFLD((AKEYE4 '%SST(SEKEYD/ACKY 4 3)') +
                          (AKEYR4 '%SST(EDSKYRPD/FYACKE 4 3)') +
                          (AKEYE9 '%SST(SEKEYD/ACKY 9 2)') (AKEYR9 +
                          '%SST(EDSKYRPD/FYACKE 9 2)') (AKEYE13 +
                          '%SST(SEKEYD/ACKY 13 3)') (AKEYR13 +
                          '%SST(EDSKYRPD/FYACKE 13 3)') (AKEYE19 +
                          '%SST(SEKEYD/ACKY 19 2)') (AKEYR19 +
                          '%SST(EDSKYRPD/FYACKE 19 2)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(SEKEYD/RECI)') (CSTN +
                          '%MIN(SEKEYD/CSTN)') (BRHA +
                          '%MIN(SEKEYD/BRHA)') (ASQN +
                          '%MIN(SEKEYD/ASQN)') (EVAM +
                          '%SUM(SEKEYD/EVAM)') (EVCY +
                          '%MIN(SEKEYD/EVCY)') (STLT +
                          '%MIN(SEKEYD/STLT)') (STLA +
                          '%MIN(SEKEYD/STLA)') (SEBR +
                          '%MIN(SEKEYD/SEBR)') (ISSR +
                          '%MIN(SEKEYD/ISSR)') (KCUST +
                          '%MIN(SEKEYD/KCUST)') (KNCA +
                          '%SUM(SEKEYD/KNCA)') (KCCY +
                          '%MIN(SEKEYD/KCCY)') (KBCA +
                          '%SUM(SEKEYD/KBCA)') (SESH +
                          '%MIN(SEKEYD/SESH)') (PRFC +
                          '%MIN(SEKEYD/PRFC)') (PTFR +
                          '%MIN(SEKEYD/PTFR)') (TNLU +
                          '%MIN(SEKEYD/TNLU)') (PEV1 +
                          '%MIN(SEKEYD/PEV1)')) OPNID(EDSKEY05)
 
             CPYFRMQRYF FROMOPNID(EDSKEY05) TOFILE(EDSKEYPD) +
                          TOMBR(&MBRN) MBROPT(*ADD) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDSKEY05)
 
/* Select matching a/c key records */
/* Member CPOSN1 on file SEKEYD */
/* Exclusion of C__bb_____DI and H__bb_____DI keys and inclusion of */
/* C__BB_____DI and H__BB_____DI keys catered for in EDSKYRPD  */
 
             OPNQRYF    FILE((SEKEYD CPOSN1) (EDSKYRPD) (SDBANKPD)) +
                          FORMAT(EDSKEYPD EDSKEYD0) JFLD((AKEYE4 +
                          AKEYR4 *EQ) (AKEYE9 AKEYR9) (AKEYE13 +
                          AKEYR13) (AKEYE19 AKEYR19)) +
                          GRPFLD(ACKY TRFR EVDT RVRS) +
                          MAPFLD((AKEYE4 '%SST(SEKEYD/ACKY 4 3)') +
                          (AKEYR4 '%SST(EDSKYRPD/FYACKE 4 3)') +
                          (AKEYE9 '%SST(SEKEYD/ACKY 9 2)') (AKEYR9 +
                          '%SST(EDSKYRPD/FYACKE 9 2)') (AKEYE13 +
                          '%SST(SEKEYD/ACKY 13 3)') (AKEYR13 +
                          '%SST(EDSKYRPD/FYACKE 13 3)') (AKEYE19 +
                          '%SST(SEKEYD/ACKY 19 2)') (AKEYR19 +
                          '%SST(EDSKYRPD/FYACKE 19 2)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(SEKEYD/RECI)') (CSTN +
                          '%MIN(SEKEYD/CSTN)') (BRHA +
                          '%MIN(SEKEYD/BRHA)') (ASQN +
                          '%MIN(SEKEYD/ASQN)') (EVAM +
                          '%SUM(SEKEYD/EVAM)') (EVCY +
                          '%MIN(SEKEYD/EVCY)') (STLT +
                          '%MIN(SEKEYD/STLT)') (STLA +
                          '%MIN(SEKEYD/STLA)') (SEBR +
                          '%MIN(SEKEYD/SEBR)') (ISSR +
                          '%MIN(SEKEYD/ISSR)') (KCUST +
                          '%MIN(SEKEYD/KCUST)') (KNCA +
                          '%SUM(SEKEYD/KNCA)') (KCCY +
                          '%MIN(SEKEYD/KCCY)') (KBCA +
                          '%SUM(SEKEYD/KBCA)') (SESH +
                          '%MIN(SEKEYD/SESH)') (PRFC +
                          '%MIN(SEKEYD/PRFC)') (PTFR +
                          '%MIN(SEKEYD/PTFR)') (TNLU +
                          '%MIN(SEKEYD/TNLU)') (PEV1 +
                          '%MIN(SEKEYD/PEV1)')) OPNID(EDSKEY06)
 
             CPYFRMQRYF FROMOPNID(EDSKEY06) TOFILE(EDSKEYPD) +
                          TOMBR(&MBRN) MBROPT(*ADD) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDSKEY06)
 
/* Select matching a/c key records */
/* Member CPOSN2 on file SEKEYD */
/* Exclusion of C__bb_____DI and H__bb_____DI keys and inclusion of */
/* C__BB_____DI and H__BB_____DI keys catered for in EDSKYRPD  */
 
             OPNQRYF    FILE((SEKEYD CPOSN2) (EDSKYRPD) (SDBANKPD)) +
                          FORMAT(EDSKEYPD EDSKEYD0) JFLD((AKEYE4 +
                          AKEYR4 *EQ) (AKEYE9 AKEYR9) (AKEYE13 +
                          AKEYR13) (AKEYE19 AKEYR19)) +
                          GRPFLD(ACKY TRFR EVDT RVRS) +
                          MAPFLD((AKEYE4 '%SST(SEKEYD/ACKY 4 3)') +
                          (AKEYR4 '%SST(EDSKYRPD/FYACKE 4 3)') +
                          (AKEYE9 '%SST(SEKEYD/ACKY 9 2)') (AKEYR9 +
                          '%SST(EDSKYRPD/FYACKE 9 2)') (AKEYE13 +
                          '%SST(SEKEYD/ACKY 13 3)') (AKEYR13 +
                          '%SST(EDSKYRPD/FYACKE 13 3)') (AKEYE19 +
                          '%SST(SEKEYD/ACKY 19 2)') (AKEYR19 +
                          '%SST(EDSKYRPD/FYACKE 19 2)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(SEKEYD/RECI)') (CSTN +
                          '%MIN(SEKEYD/CSTN)') (BRHA +
                          '%MIN(SEKEYD/BRHA)') (ASQN +
                          '%MIN(SEKEYD/ASQN)') (EVAM +
                          '%SUM(SEKEYD/EVAM)') (EVCY +
                          '%MIN(SEKEYD/EVCY)') (STLT +
                          '%MIN(SEKEYD/STLT)') (STLA +
                          '%MIN(SEKEYD/STLA)') (SEBR +
                          '%MIN(SEKEYD/SEBR)') (ISSR +
                          '%MIN(SEKEYD/ISSR)') (KCUST +
                          '%MIN(SEKEYD/KCUST)') (KNCA +
                          '%SUM(SEKEYD/KNCA)') (KCCY +
                          '%MIN(SEKEYD/KCCY)') (KBCA +
                          '%SUM(SEKEYD/KBCA)') (SESH +
                          '%MIN(SEKEYD/SESH)') (PRFC +
                          '%MIN(SEKEYD/PRFC)') (PTFR +
                          '%MIN(SEKEYD/PTFR)') (TNLU +
                          '%MIN(SEKEYD/TNLU)') (PEV1 +
                          '%MIN(SEKEYD/PEV1)')) OPNID(EDSKEY07)
 
             CPYFRMQRYF FROMOPNID(EDSKEY07) TOFILE(EDSKEYPD) +
                          TOMBR(&MBRN) MBROPT(*ADD) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDSKEY07)
 
/* Select matching a/c key records */
/* Member DEPOTMVT on file SEKEYD */
/* Exclusion of C__bb_____DI and H__bb_____DI keys and inclusion of */
/* C__BB_____DI and H__BB_____DI keys catered for in EDSKYRPD  */
 
             OPNQRYF    FILE((SEKEYD DEPOTMVT) (EDSKYRPD) +
                          (SDBANKPD)) FORMAT(EDSKEYPD EDSKEYD0) +
                          JFLD((AKEYE4 AKEYR4 *EQ) (AKEYE9 AKEYR9) +
                          (AKEYE13 AKEYR13) (AKEYE19 AKEYR19)) +
                          GRPFLD(ACKY TRFR EVDT RVRS) +
                          MAPFLD((AKEYE4 '%SST(SEKEYD/ACKY 4 3)') +
                          (AKEYR4 '%SST(EDSKYRPD/FYACKE 4 3)') +
                          (AKEYE9 '%SST(SEKEYD/ACKY 9 2)') (AKEYR9 +
                          '%SST(EDSKYRPD/FYACKE 9 2)') (AKEYE13 +
                          '%SST(SEKEYD/ACKY 13 3)') (AKEYR13 +
                          '%SST(EDSKYRPD/FYACKE 13 3)') (AKEYE19 +
                          '%SST(SEKEYD/ACKY 19 2)') (AKEYR19 +
                          '%SST(EDSKYRPD/FYACKE 19 2)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(SEKEYD/RECI)') (CSTN +
                          '%MIN(SEKEYD/CSTN)') (BRHA +
                          '%MIN(SEKEYD/BRHA)') (ASQN +
                          '%MIN(SEKEYD/ASQN)') (EVAM +
                          '%SUM(SEKEYD/EVAM)') (EVCY +
                          '%MIN(SEKEYD/EVCY)') (STLT +
                          '%MIN(SEKEYD/STLT)') (STLA +
                          '%MIN(SEKEYD/STLA)') (SEBR +
                          '%MIN(SEKEYD/SEBR)') (ISSR +
                          '%MIN(SEKEYD/ISSR)') (KCUST +
                          '%MIN(SEKEYD/KCUST)') (KNCA +
                          '%SUM(SEKEYD/KNCA)') (KCCY +
                          '%MIN(SEKEYD/KCCY)') (KBCA +
                          '%SUM(SEKEYD/KBCA)') (SESH +
                          '%MIN(SEKEYD/SESH)') (PRFC +
                          '%MIN(SEKEYD/PRFC)') (PTFR +
                          '%MIN(SEKEYD/PTFR)') (TNLU +
                          '%MIN(SEKEYD/TNLU)') (PEV1 +
                          '%MIN(SEKEYD/PEV1)')) OPNID(EDSKEY08)
 
             CPYFRMQRYF FROMOPNID(EDSKEY08) TOFILE(EDSKEYPD) +
                          TOMBR(&MBRN) MBROPT(*ADD) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDSKEY08)
 
/* Select matching a/c key records */
/* Member DPOSN1 on file SEKEYD */
/* Exclusion of C__bb_____DI and H__bb_____DI keys and inclusion of */
/* C__BB_____DI and H__BB_____DI keys catered for in EDSKYRPD  */
 
             OPNQRYF    FILE((SEKEYD DPOSN1) (EDSKYRPD) (SDBANKPD)) +
                          FORMAT(EDSKEYPD EDSKEYD0) JFLD((AKEYE4 +
                          AKEYR4 *EQ) (AKEYE9 AKEYR9) (AKEYE13 +
                          AKEYR13) (AKEYE19 AKEYR19)) +
                          GRPFLD(ACKY TRFR EVDT RVRS) +
                          MAPFLD((AKEYE4 '%SST(SEKEYD/ACKY 4 3)') +
                          (AKEYR4 '%SST(EDSKYRPD/FYACKE 4 3)') +
                          (AKEYE9 '%SST(SEKEYD/ACKY 9 2)') (AKEYR9 +
                          '%SST(EDSKYRPD/FYACKE 9 2)') (AKEYE13 +
                          '%SST(SEKEYD/ACKY 13 3)') (AKEYR13 +
                          '%SST(EDSKYRPD/FYACKE 13 3)') (AKEYE19 +
                          '%SST(SEKEYD/ACKY 19 2)') (AKEYR19 +
                          '%SST(EDSKYRPD/FYACKE 19 2)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(SEKEYD/RECI)') (CSTN +
                          '%MIN(SEKEYD/CSTN)') (BRHA +
                          '%MIN(SEKEYD/BRHA)') (ASQN +
                          '%MIN(SEKEYD/ASQN)') (EVAM +
                          '%SUM(SEKEYD/EVAM)') (EVCY +
                          '%MIN(SEKEYD/EVCY)') (STLT +
                          '%MIN(SEKEYD/STLT)') (STLA +
                          '%MIN(SEKEYD/STLA)') (SEBR +
                          '%MIN(SEKEYD/SEBR)') (ISSR +
                          '%MIN(SEKEYD/ISSR)') (KCUST +
                          '%MIN(SEKEYD/KCUST)') (KNCA +
                          '%SUM(SEKEYD/KNCA)') (KCCY +
                          '%MIN(SEKEYD/KCCY)') (KBCA +
                          '%SUM(SEKEYD/KBCA)') (SESH +
                          '%MIN(SEKEYD/SESH)') (PRFC +
                          '%MIN(SEKEYD/PRFC)') (PTFR +
                          '%MIN(SEKEYD/PTFR)') (TNLU +
                          '%MIN(SEKEYD/TNLU)') (PEV1 +
                          '%MIN(SEKEYD/PEV1)')) OPNID(EDSKEY09)
 
             CPYFRMQRYF FROMOPNID(EDSKEY09) TOFILE(EDSKEYPD) +
                          TOMBR(&MBRN) MBROPT(*ADD) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDSKEY09)
 
/* Select matching a/c key records */
/* Member DPOSN2 on file SEKEYD */
/* Exclusion of C__bb_____DI and H__bb_____DI keys and inclusion of */
/* C__BB_____DI and H__BB_____DI keys catered for in EDSKYRPD  */
 
             OPNQRYF    FILE((SEKEYD DPOSN2) (EDSKYRPD) (SDBANKPD)) +
                          FORMAT(EDSKEYPD EDSKEYD0) JFLD((AKEYE4 +
                          AKEYR4 *EQ) (AKEYE9 AKEYR9) (AKEYE13 +
                          AKEYR13) (AKEYE19 AKEYR19)) +
                          GRPFLD(ACKY TRFR EVDT RVRS) +
                          MAPFLD((AKEYE4 '%SST(SEKEYD/ACKY 4 3)') +
                          (AKEYR4 '%SST(EDSKYRPD/FYACKE 4 3)') +
                          (AKEYE9 '%SST(SEKEYD/ACKY 9 2)') (AKEYR9 +
                          '%SST(EDSKYRPD/FYACKE 9 2)') (AKEYE13 +
                          '%SST(SEKEYD/ACKY 13 3)') (AKEYR13 +
                          '%SST(EDSKYRPD/FYACKE 13 3)') (AKEYE19 +
                          '%SST(SEKEYD/ACKY 19 2)') (AKEYR19 +
                          '%SST(EDSKYRPD/FYACKE 19 2)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(SEKEYD/RECI)') (CSTN +
                          '%MIN(SEKEYD/CSTN)') (BRHA +
                          '%MIN(SEKEYD/BRHA)') (ASQN +
                          '%MIN(SEKEYD/ASQN)') (EVAM +
                          '%SUM(SEKEYD/EVAM)') (EVCY +
                          '%MIN(SEKEYD/EVCY)') (STLT +
                          '%MIN(SEKEYD/STLT)') (STLA +
                          '%MIN(SEKEYD/STLA)') (SEBR +
                          '%MIN(SEKEYD/SEBR)') (ISSR +
                          '%MIN(SEKEYD/ISSR)') (KCUST +
                          '%MIN(SEKEYD/KCUST)') (KNCA +
                          '%SUM(SEKEYD/KNCA)') (KCCY +
                          '%MIN(SEKEYD/KCCY)') (KBCA +
                          '%SUM(SEKEYD/KBCA)') (SESH +
                          '%MIN(SEKEYD/SESH)') (PRFC +
                          '%MIN(SEKEYD/PRFC)') (PTFR +
                          '%MIN(SEKEYD/PTFR)') (TNLU +
                          '%MIN(SEKEYD/TNLU)') (PEV1 +
                          '%MIN(SEKEYD/PEV1)')) OPNID(EDSKEY10)
 
             CPYFRMQRYF FROMOPNID(EDSKEY10) TOFILE(EDSKEYPD) +
                          TOMBR(&MBRN) MBROPT(*ADD) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDSKEY10)
 
/* Select matching a/c key records */
/* Member MMREVAL on file SEKEYD */
/* Exclusion of C__bb_____DI and H__bb_____DI keys and inclusion of */
/* C__BB_____DI and H__BB_____DI keys catered for in EDSKYRPD  */
 
             OPNQRYF    FILE((SEKEYD MMREVAL) (EDSKYRPD) (SDBANKPD)) +
                          FORMAT(EDSKEYPD EDSKEYD0) JFLD((AKEYE4 +
                          AKEYR4 *EQ) (AKEYE9 AKEYR9) (AKEYE13 +
                          AKEYR13) (AKEYE19 AKEYR19)) +
                          GRPFLD(ACKY TRFR EVDT RVRS) +
                          MAPFLD((AKEYE4 '%SST(SEKEYD/ACKY 4 3)') +
                          (AKEYR4 '%SST(EDSKYRPD/FYACKE 4 3)') +
                          (AKEYE9 '%SST(SEKEYD/ACKY 9 2)') (AKEYR9 +
                          '%SST(EDSKYRPD/FYACKE 9 2)') (AKEYE13 +
                          '%SST(SEKEYD/ACKY 13 3)') (AKEYR13 +
                          '%SST(EDSKYRPD/FYACKE 13 3)') (AKEYE19 +
                          '%SST(SEKEYD/ACKY 19 2)') (AKEYR19 +
                          '%SST(EDSKYRPD/FYACKE 19 2)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(SEKEYD/RECI)') (CSTN +
                          '%MIN(SEKEYD/CSTN)') (BRHA +
                          '%MIN(SEKEYD/BRHA)') (ASQN +
                          '%MIN(SEKEYD/ASQN)') (EVAM +
                          '%SUM(SEKEYD/EVAM)') (EVCY +
                          '%MIN(SEKEYD/EVCY)') (STLT +
                          '%MIN(SEKEYD/STLT)') (STLA +
                          '%MIN(SEKEYD/STLA)') (SEBR +
                          '%MIN(SEKEYD/SEBR)') (ISSR +
                          '%MIN(SEKEYD/ISSR)') (KCUST +
                          '%MIN(SEKEYD/KCUST)') (KNCA +
                          '%SUM(SEKEYD/KNCA)') (KCCY +
                          '%MIN(SEKEYD/KCCY)') (KBCA +
                          '%SUM(SEKEYD/KBCA)') (SESH +
                          '%MIN(SEKEYD/SESH)') (PRFC +
                          '%MIN(SEKEYD/PRFC)') (PTFR +
                          '%MIN(SEKEYD/PTFR)') (TNLU +
                          '%MIN(SEKEYD/TNLU)') (PEV1 +
                          '%MIN(SEKEYD/PEV1)')) OPNID(EDSKEY11)
 
             CPYFRMQRYF FROMOPNID(EDSKEY11) TOFILE(EDSKEYPD) +
                          TOMBR(&MBRN) MBROPT(*ADD) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDSKEY11)
 
/* Select matching a/c key records */
/* Member PSETTLE on file SEKEYD */
/* Exclusion of C__bb_____DI and H__bb_____DI keys and inclusion of */
/* C__BB_____DI and H__BB_____DI keys catered for in EDSKYRPD  */
 
             OPNQRYF    FILE((SEKEYD PSETTLE) (EDSKYRPD) (SDBANKPD)) +
                          FORMAT(EDSKEYPD EDSKEYD0) JFLD((AKEYE4 +
                          AKEYR4 *EQ) (AKEYE9 AKEYR9) (AKEYE13 +
                          AKEYR13) (AKEYE19 AKEYR19)) +
                          GRPFLD(ACKY TRFR EVDT RVRS) +
                          MAPFLD((AKEYE4 '%SST(SEKEYD/ACKY 4 3)') +
                          (AKEYR4 '%SST(EDSKYRPD/FYACKE 4 3)') +
                          (AKEYE9 '%SST(SEKEYD/ACKY 9 2)') (AKEYR9 +
                          '%SST(EDSKYRPD/FYACKE 9 2)') (AKEYE13 +
                          '%SST(SEKEYD/ACKY 13 3)') (AKEYR13 +
                          '%SST(EDSKYRPD/FYACKE 13 3)') (AKEYE19 +
                          '%SST(SEKEYD/ACKY 19 2)') (AKEYR19 +
                          '%SST(EDSKYRPD/FYACKE 19 2)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(SEKEYD/RECI)') (CSTN +
                          '%MIN(SEKEYD/CSTN)') (BRHA +
                          '%MIN(SEKEYD/BRHA)') (ASQN +
                          '%MIN(SEKEYD/ASQN)') (EVAM +
                          '%SUM(SEKEYD/EVAM)') (EVCY +
                          '%MIN(SEKEYD/EVCY)') (STLT +
                          '%MIN(SEKEYD/STLT)') (STLA +
                          '%MIN(SEKEYD/STLA)') (SEBR +
                          '%MIN(SEKEYD/SEBR)') (ISSR +
                          '%MIN(SEKEYD/ISSR)') (KCUST +
                          '%MIN(SEKEYD/KCUST)') (KNCA +
                          '%SUM(SEKEYD/KNCA)') (KCCY +
                          '%MIN(SEKEYD/KCCY)') (KBCA +
                          '%SUM(SEKEYD/KBCA)') (SESH +
                          '%MIN(SEKEYD/SESH)') (PRFC +
                          '%MIN(SEKEYD/PRFC)') (PTFR +
                          '%MIN(SEKEYD/PTFR)') (TNLU +
                          '%MIN(SEKEYD/TNLU)') (PEV1 +
                          '%MIN(SEKEYD/PEV1)')) OPNID(EDSKEY12)
 
             CPYFRMQRYF FROMOPNID(EDSKEY12) TOFILE(EDSKEYPD) +
                          TOMBR(&MBRN) MBROPT(*ADD) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDSKEY12)
 
/* Select matching a/c key records */
/* Member REDEMP on file SEKEYD */
/* Exclusion of C__bb_____DI and H__bb_____DI keys and inclusion of */
/* C__BB_____DI and H__BB_____DI keys catered for in EDSKYRPD  */
 
             OPNQRYF    FILE((SEKEYD REDEMP) (EDSKYRPD) (SDBANKPD)) +
                          FORMAT(EDSKEYPD EDSKEYD0) JFLD((AKEYE4 +
                          AKEYR4 *EQ) (AKEYE9 AKEYR9) (AKEYE13 +
                          AKEYR13) (AKEYE19 AKEYR19)) +
                          GRPFLD(ACKY TRFR EVDT RVRS) +
                          MAPFLD((AKEYE4 '%SST(SEKEYD/ACKY 4 3)') +
                          (AKEYR4 '%SST(EDSKYRPD/FYACKE 4 3)') +
                          (AKEYE9 '%SST(SEKEYD/ACKY 9 2)') (AKEYR9 +
                          '%SST(EDSKYRPD/FYACKE 9 2)') (AKEYE13 +
                          '%SST(SEKEYD/ACKY 13 3)') (AKEYR13 +
                          '%SST(EDSKYRPD/FYACKE 13 3)') (AKEYE19 +
                          '%SST(SEKEYD/ACKY 19 2)') (AKEYR19 +
                          '%SST(EDSKYRPD/FYACKE 19 2)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(SEKEYD/RECI)') (CSTN +
                          '%MIN(SEKEYD/CSTN)') (BRHA +
                          '%MIN(SEKEYD/BRHA)') (ASQN +
                          '%MIN(SEKEYD/ASQN)') (EVAM +
                          '%SUM(SEKEYD/EVAM)') (EVCY +
                          '%MIN(SEKEYD/EVCY)') (STLT +
                          '%MIN(SEKEYD/STLT)') (STLA +
                          '%MIN(SEKEYD/STLA)') (SEBR +
                          '%MIN(SEKEYD/SEBR)') (ISSR +
                          '%MIN(SEKEYD/ISSR)') (KCUST +
                          '%MIN(SEKEYD/KCUST)') (KNCA +
                          '%SUM(SEKEYD/KNCA)') (KCCY +
                          '%MIN(SEKEYD/KCCY)') (KBCA +
                          '%SUM(SEKEYD/KBCA)') (SESH +
                          '%MIN(SEKEYD/SESH)') (PRFC +
                          '%MIN(SEKEYD/PRFC)') (PTFR +
                          '%MIN(SEKEYD/PTFR)') (TNLU +
                          '%MIN(SEKEYD/TNLU)') (PEV1 +
                          '%MIN(SEKEYD/PEV1)')) OPNID(EDSKEY13)
 
             CPYFRMQRYF FROMOPNID(EDSKEY13) TOFILE(EDSKEYPD) +
                          TOMBR(&MBRN) MBROPT(*ADD) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDSKEY13)
 
/* Select matching a/c key records */
/* Member TRADE on file SEKEYD */
/* Exclusion of C__bb_____DI and H__bb_____DI keys and inclusion of */
/* C__BB_____DI and H__BB_____DI keys catered for in EDSKYRPD  */
 
             OPNQRYF    FILE((SEKEYD TRADE) (EDSKYRPD) (SDBANKPD)) +
                          FORMAT(EDSKEYPD EDSKEYD0) JFLD((AKEYE4 +
                          AKEYR4 *EQ) (AKEYE9 AKEYR9) (AKEYE13 +
                          AKEYR13) (AKEYE19 AKEYR19)) +
                          GRPFLD(ACKY TRFR EVDT RVRS) +
                          MAPFLD((AKEYE4 '%SST(SEKEYD/ACKY 4 3)') +
                          (AKEYR4 '%SST(EDSKYRPD/FYACKE 4 3)') +
                          (AKEYE9 '%SST(SEKEYD/ACKY 9 2)') (AKEYR9 +
                          '%SST(EDSKYRPD/FYACKE 9 2)') (AKEYE13 +
                          '%SST(SEKEYD/ACKY 13 3)') (AKEYR13 +
                          '%SST(EDSKYRPD/FYACKE 13 3)') (AKEYE19 +
                          '%SST(SEKEYD/ACKY 19 2)') (AKEYR19 +
                          '%SST(EDSKYRPD/FYACKE 19 2)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(SEKEYD/RECI)') (CSTN +
                          '%MIN(SEKEYD/CSTN)') (BRHA +
                          '%MIN(SEKEYD/BRHA)') (ASQN +
                          '%MIN(SEKEYD/ASQN)') (EVAM +
                          '%SUM(SEKEYD/EVAM)') (EVCY +
                          '%MIN(SEKEYD/EVCY)') (STLT +
                          '%MIN(SEKEYD/STLT)') (STLA +
                          '%MIN(SEKEYD/STLA)') (SEBR +
                          '%MIN(SEKEYD/SEBR)') (ISSR +
                          '%MIN(SEKEYD/ISSR)') (KCUST +
                          '%MIN(SEKEYD/KCUST)') (KNCA +
                          '%SUM(SEKEYD/KNCA)') (KCCY +
                          '%MIN(SEKEYD/KCCY)') (KBCA +
                          '%SUM(SEKEYD/KBCA)') (SESH +
                          '%MIN(SEKEYD/SESH)') (PRFC +
                          '%MIN(SEKEYD/PRFC)') (PTFR +
                          '%MIN(SEKEYD/PTFR)') (TNLU +
                          '%MIN(SEKEYD/TNLU)') (PEV1 +
                          '%MIN(SEKEYD/PEV1)')) OPNID(EDSKEY14)
 
             CPYFRMQRYF FROMOPNID(EDSKEY14) TOFILE(EDSKEYPD) +
                          TOMBR(&MBRN) MBROPT(*ADD) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDSKEY14)
 
/* Select matching a/c key records */
/* Member TSETTLE on file SEKEYD */
/* Exclusion of C__bb_____DI and H__bb_____DI keys and inclusion of */
/* C__BB_____DI and H__BB_____DI keys catered for in EDSKYRPD  */
 
             OPNQRYF    FILE((SEKEYD TSETTLE) (EDSKYRPD) (SDBANKPD)) +
                          FORMAT(EDSKEYPD EDSKEYD0) JFLD((AKEYE4 +
                          AKEYR4 *EQ) (AKEYE9 AKEYR9) (AKEYE13 +
                          AKEYR13) (AKEYE19 AKEYR19)) +
                          GRPFLD(ACKY TRFR EVDT RVRS) +
                          MAPFLD((AKEYE4 '%SST(SEKEYD/ACKY 4 3)') +
                          (AKEYR4 '%SST(EDSKYRPD/FYACKE 4 3)') +
                          (AKEYE9 '%SST(SEKEYD/ACKY 9 2)') (AKEYR9 +
                          '%SST(EDSKYRPD/FYACKE 9 2)') (AKEYE13 +
                          '%SST(SEKEYD/ACKY 13 3)') (AKEYR13 +
                          '%SST(EDSKYRPD/FYACKE 13 3)') (AKEYE19 +
                          '%SST(SEKEYD/ACKY 19 2)') (AKEYR19 +
                          '%SST(EDSKYRPD/FYACKE 19 2)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (RECI +
                          '%MIN(SEKEYD/RECI)') (CSTN +
                          '%MIN(SEKEYD/CSTN)') (BRHA +
                          '%MIN(SEKEYD/BRHA)') (ASQN +
                          '%MIN(SEKEYD/ASQN)') (EVAM +
                          '%SUM(SEKEYD/EVAM)') (EVCY +
                          '%MIN(SEKEYD/EVCY)') (STLT +
                          '%MIN(SEKEYD/STLT)') (STLA +
                          '%MIN(SEKEYD/STLA)') (SEBR +
                          '%MIN(SEKEYD/SEBR)') (ISSR +
                          '%MIN(SEKEYD/ISSR)') (KCUST +
                          '%MIN(SEKEYD/KCUST)') (KNCA +
                          '%SUM(SEKEYD/KNCA)') (KCCY +
                          '%MIN(SEKEYD/KCCY)') (KBCA +
                          '%SUM(SEKEYD/KBCA)') (SESH +
                          '%MIN(SEKEYD/SESH)') (PRFC +
                          '%MIN(SEKEYD/PRFC)') (PTFR +
                          '%MIN(SEKEYD/PTFR)') (TNLU +
                          '%MIN(SEKEYD/TNLU)') (PEV1 +
                          '%MIN(SEKEYD/PEV1)')) OPNID(EDSKEY15)
 
             CPYFRMQRYF FROMOPNID(EDSKEY15) TOFILE(EDSKEYPD) +
                          TOMBR(&MBRN) MBROPT(*ADD) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDSKEY15)
             ENDDO
 
/* Normal termination */
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(ENDCLPGM))
 
 
/* Abnormal termination */
ABNOR:
 
             SNDPGMMSG  MSG('EDC0518 - ED Copy of SEKEYD TERMINATED +
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
