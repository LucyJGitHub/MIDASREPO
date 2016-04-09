/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Copy of LKEYFED')                            */
/********************************************************************/
/*                                                                  */
/*       Midas - Export Data Interface Module                       */
/*                                                                  */
/*       EDC0516 -  Copy of LKEYFED                                 */
/*                                                                  */
/*       Function : This program copies selected a/c key records    */
/*                  from LKEYFED to the ED Extract file EDLFEEPD.   */
/*                  A/c key records are copied if they match one    */
/*                  of the a/c key 'Skeletons' in EDLFERPD.         */
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
/*       LAST AMEND NO. CED006 *CREATE     DATE 24JUL97             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
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
 
/* Call AOBUTFR0 to check file EDLFEEPD selected for transfer to GM */
 
             CALL       PGM(AOBUTFR0) PARM('EDLFEEPD' '          ' +
                          &RTCD &FMT)
 
/* EDLFEEPD is selected for transfer  */
 
             IF         COND(&RTCD *NE '*FAILED') THEN(DO)
 
/* Select matching a/c key records */
             OPNQRYF    FILE((LKEYFED) (EDLFERPD) (SDBANKPD)) +
                          FORMAT(EDLFEEPD EDLFEED0) JFLD((AKEYE10 +
                          AKEYR10)) GRPFLD(LKLNNO LKCNUM LKEDAT +
                          LKAKEY LKREVI LKECCY) MAPFLD((AKEYE10 +
                          '%SST(LKEYFED/LKAKEY 10 1)') (AKEYR10 +
                          '%SST(EDLFERPD/FYAKEY 10 1)') (AGRDNB +
                          '%MIN(SDBANKPD/BJRDNB)') (LKRECI +
                          '%MIN(LKEYFED/LKRECI)') (LKBRCD +
                          '%MIN(LKEYFED/LKBRCD)') (LKACSQ +
                          '%MIN(LKEYFED/LKACSQ)') (LKEAMT +
                          '%SUM(LKEYFED/LKEAMT)') (LKSETP +
                          '%MIN(LKEYFED/LKSETP)') (LKOSAC +
                          '%MIN(LKEYFED/LKOSAC)') (LKOTHA +
                          '%SUM(LKEYFED/LKOTHA)') (LKOTHC +
                          '%MIN(LKEYFED/LKOTHC)') (LKEXRT +
                          '%MIN(LKEYFED/LKEXRT)') (LKSTDT +
                          '%MIN(LKEYFED/LKSTDT)') (LKSLID +
                          '%MIN(LKEYFED/LKSLID)') (LKMDAT +
                          '%MIN(LKEYFED/LKMDAT)') (LKBRTT +
                          '%MIN(LKEYFED/LKBRTT)') (LKBRTE +
                          '%MIN(LKEYFED/LKBRTE)') (LKRTSP +
                          '%MIN(LKEYFED/LKRTSP)') (LKINTR +
                          '%MIN(LKEYFED/LKINTR)') (LKSSEQ +
                          '%MIN(LKEYFED/LKSSEQ)') (LKCPAM +
                          '%SUM(LKEYFED/LKCPAM)') (LKPACD +
                          '%MIN(LKEYFED/LKPACD)') (LKCFTP +
                          '%MIN(LKEYFED/LKCFTP)') (LKFAMT +
                          '%SUM(LKEYFED/LKFAMT)') (LKPRFC +
                          '%MIN(LKEYFED/LKPRFC)') (LKOSBR +
                          '%MIN(LKEYFED/LKOSBR)') (LKCMPY +
                          '%MIN(LKEYFED/LKCMPY)') (LKBOKC +
                          '%MIN(LKEYFED/LKBOKC)') (LKADAT +
                          '%SUM(LKEYFED/LKADAT)')) OPNID(EDLFEEPD)
 
             CPYFRMQRYF FROMOPNID(EDLFEEPD) TOFILE(EDLFEEPD) +
                          TOMBR(&MBRN) MBROPT(*REPLACE) FMTOPT(*NOCHK)
/* Close */
             CLOF       OPNID(EDLFEEPD)
             ENDDO
 
/* Normal termination */
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(ENDCLPGM))
 
 
/* Abnormal termination */
ABNOR:
 
             SNDPGMMSG  MSG('EDC0516 - ED Copy of LKEYFED TERMINATED +
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
