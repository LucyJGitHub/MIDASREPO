/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD PM Customer Details List')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC0391 - SD Portfolio Management Customer Details          */
/*                 report                                            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPM005             Date 31Jul96              */
/*                      R00300             Date 28Aug90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase II                           */
/*                Focus Group Changes Upgraded to DBA                */
/*       R00300 - Message file changes.                              */
/*                                                                   */
/********************************************************************/
/*********** PGM        PARM(&MODE)                                */ /*CPM005*/
             PGM        PARM(&MODE &RSEQ &RLVL &RENT)                 /*CPM005*/
/**/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RUNDA) TYPE(*CHAR) LEN(5)
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)              */ /*CPM005*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*CPM005*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*CPM005*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*CPM005*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*CPM005*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/* Global monitor message                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
/**/
/*  Set off switches:                                                         */
             CHGJOB     SWS(00000000)
/**/
/*  Retrieve MIDAS Run Date                                                   */
             RTVDTAARA  DTAARA(PMSTAT (6 5)) RTNVAR(&RUNDA)
/*********** OVRDBF     FILE(SDPLCSPO) TOFILE(PMCUSDPP) SHARE(*YES)*/ /*CPM005*/
             OVRDBF     FILE(PMCUSDQ0) TOFILE(PMCUSDPD) SHARE(*YES)   /*CPM005*/
/**/
/** Open Query File                                                          **/
             IF         COND(&MODE *EQ '1') THEN(DO)
/*********** OPNQRYF    FILE((PMCUSDPP) (PMDOCCPP)) FORMAT( +      */ /*CPM005*/
/***********              SDPLCSPO) KEYFLD((P6CNUM) (P3DOCS)) +    */ /*CPM005*/
/***********              JFLD((PMCUSDPP/P6DCCO PMDOCCPP/P3DCCO)) +*/ /*CPM005*/
/***********              QRYSLT('WWLCD *EQ "' *CAT &RUNDA *CAT ' +*/ /*CPM005*/
/***********              " MAPFLD((W1LCD P6LCD *ZONED 5) (WWLCD + */ /*CPM005*/
/***********              W1LCD *CHAR 5))                          */ /*CPM005*/
             OPNQRYF    FILE((PMCUSDPD) (PMDOCCPD)) FORMAT(PMCUSDQ0) +
                          KEYFLD((P6CNUM) (P3DOCS)) +
                          JFLD((PMCUSDPD/P6DCCO PMDOCCPD/P3DCCO)) +
                          QRYSLT('WWLCD *EQ "' *CAT &RUNDA *CAT '" ') +
                          MAPFLD((W1LCD P6LCD *ZONED 5) (WWLCD W1LCD +
                          *CHAR 5))                                   /*CPM005*/
             ENDDO
 
             IF         COND(&MODE *EQ '2') THEN(DO)
/*********** OPNQRYF    FILE((PMCUSDPP) (PMDOCCPP)) FORMAT( +      */ /*CPM005*/
/***********              SDPLCSPO) KEYFLD((P6CNUM) (P3DOCS)) +    */ /*CPM005*/
/***********              JFLD((PMCUSDPP/P6DCCO PMDOCCPP/ +        */ /*CPM005*/
/***********              P3DCCO)) QRYSLT('P6RECI *EQ "D")         */ /*CPM005*/
             OPNQRYF    FILE((PMCUSDPD) (PMDOCCPD)) FORMAT(PMCUSDQ0) +
                          KEYFLD((P6CNUM) (P3DOCS)) +
                          JFLD((PMCUSDPD/P6DCCO PMDOCCPD/P3DCCO)) +
                          QRYSLT('P6RECI *EQ "D"')                    /*CPM005*/
             ENDDO
/**/
/*********** CALL       PGM(SD1065) PARM(&MODE)                    */ /*CPM005*/
             CALL       PGM(SD0391P) PARM(&MODE &RSEQ)                /*CPM005*/
/*********** CLOF       OPNID(PMCUSDPP)                            */ /*CPM005*/
             CLOF       OPNID(PMCUSDPD)                               /*CPM005*/
             DLTOVR     FILE(*ALL)
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)      */ /*CPM005*/
/*                                                                    /*R00300*/
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/***********     SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) +        */ /*CPM005*/
/***********              MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)        */ /*CPM005*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*CPM005*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
/*                                                                    /*R00300*/
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
/*  ERROR IN CL PROGRAM  */
 ENDTAG:     DMPCLPGM
 
/***END:***     ENDPGM                                             */ /*CPM005*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*CPM005*/
