/*********************************************************************/
/*STD    CLPBASE                                                     */
/**** *  TEXT('Midas RE INACTIVE AND BLOCKED A/C'S REPORT')          */                 /*MD060753*/
/*EXI *  TEXT('Midas RE INACTIVE AND BLOCKED A/C S REPORT')          */                 /*MD060753*/
/*********************************************************************/
/*                                                                   */
/*       Midas       Retail Module                               */
/*                                                                   */
/*       REC3872 - INACTIVE AND BLOCKED ACCOUNTS REPORT              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. AR945431           Date 16Apr12              */
/*       Prev Amend No. MD060753           Date 10Nov22              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR945431 - RE3872 is incorrectly excluding Non-Retail       */
/*                  Accounts. Removed exclusion of Non-Retail Accts. */
/*                  (Child: AR945434)                                */
/*                  Redesigned as switchable via System Values       */
/*       MD060753 - Error in source compilation                      */
/*       MD046248 - Finastra Rebranding                              */
/*       S01413 - Retail 3 Incorporation.                            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM     PARM(&RSEQ &RLEV &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(*BLANKS)                    /*AR945431*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(20)                                  /*AR945431*/
             DCL        VAR(&OPTN1) TYPE(*CHAR) LEN(20)                                 /*AR945431*/
             DCL        VAR(&VAL) TYPE(*CHAR) LEN(200)                                  /*AR945431*/
             DCL        VAR(&VAL1) TYPE(*CHAR) LEN(200)                                 /*AR945431*/
             DCL        VAR(&NONRETL) TYPE(*CHAR) LEN(1)                                /*AR945431*/
/**/
             SNDPGMMSG  MSG('REC3872 - Inactive & Blocked Accounts +
                          Report') TOMSGQ(MRUNQ)
/**/
             /* Check system value for Include Non Retail Accounts in the report */

             CHGVAR     VAR(&RTCD) VALUE(*BLANKS)                                       /*AR945431*/
             CHGVAR     VAR(&OPTN) VALUE('IncludeNonRetailRpt')                         /*AR945431*/
             CHGVAR     VAR(&VAL) VALUE(*BLANKS)                                        /*AR945431*/

             CALL       PGM(AOSVALR0) PARM(&RTCD &OPTN &VAL &OPTN1 &VAL1 &OPTN1 +
                          &VAL1 &OPTN1 &VAL1 &OPTN1 &VAL1 &OPTN1 &VAL1 &OPTN1 +
                          &VAL1 &OPTN1 &VAL1 &OPTN1 &VAL1 &OPTN1 &VAL1)                 /*AR945431*/

             IF         COND(&RTCD *NE '       ') THEN(CHGVAR VAR(&NONRETL) +
                          VALUE('N'))                                                   /*AR945431*/



             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR VAR(&NONRETL) +
                          VALUE(&VAL))                                                  /*AR945431*/
/**/
             CHGJOB     SWS(00000000)
/**/
             OVRDBF     SIBP ACCNTAB SHARE(*YES)
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                          THEN(DO)
/*/COPY WNCPYSRC,REC3872001                                          */
   IF         COND(&NONRETL *NE 'Y')    THEN(DO)                                        /*AR945431*/

             OPNQRYF    FILE((ACCNTAB) (CLINTCB)) FORMAT(IBPAIB) +
                          QRYSLT('(ACCNTAB/RECI *EQ "D" *AND +
                          ACCNTAB/ATYP *EQ "R" *AND ACCNTAB/BRCA +
                          *EQ "' *CAT &RENT *CAT '" *AND +
                          ACCNTAB/RETB *NE X"00" *AND ACCNTAB/RETB +
                          *NE X"02" *AND ACCNTAB/RETB *NE X"04" +
                          *AND  ACCNTAB/RETB *NE X"40" *AND +
                          ACCNTAB/RETB *NE X"42" *AND ACCNTAB/RETB +
                          *NE X"44" *AND  ACCNTAB/RETB *NE X"80" +
                          *AND ACCNTAB/RETB *NE X"82" *AND +
                          ACCNTAB/RETB *NE X"84" *AND  ACCNTAB/RETB +
                          *NE X"C0" *AND ACCNTAB/RETB *NE X"C2" +
                          *AND ACCNTAB/RETB *NE X"C4")') +
                          KEYFLD((ACCNTAB/BRCA) (CLINTCB/ACOC) +
                          (ACCNTAB/CCY) (ACCNTAB/CNUM) +
                          (ACCNTAB/ACOD) (ACCNTAB/ACSQ)) +
                          JFLD((ACCNTAB/CNUM CLINTCB/CNUM)) +
                          MAPFLD((RECI 'ACCNTAB/RECI') (BRCA +
                          'ACCNTAB/BRCA') (CNUM 'ACCNTAB/CNUM') +
                          (CCY 'ACCNTAB/CCY') (ACOD 'ACCNTAB/ACOD') +
                          (ACSQ 'ACCNTAB/ACSQ') (ACNO +
                          'ACCNTAB/ACNO') (CRNM 'CLINTCB/CRNM') +
                          (GRBL 'ACCNTAB/LDBL') (NETB +
                          'ACCNTAB/CLBL') (LACD 'ACCNTAB/LACD') +
                          (RETB 'ACCNTAB/RETB') (ACOC +
                          'CLINTCB/ACOC') (ZZ009 '%SST(ZZ024 1 9)' +
                          *CHAR 9)) IGNDECERR(*YES)
   ENDDO                                                                                /*AR945431*/

             ELSE       CMD(DO)                                                         /*AR945431*/

                OPNQRYF    FILE((ACCNTAB) (CLINTCB)) FORMAT(IBPAIB) +
                             QRYSLT('(ACCNTAB/RECI *EQ "D" *AND ACCNTAB/BRCA *EQ +
                             "' *CAT &RENT *CAT '" *AND ACCNTAB/RETB *NE X"00" +
                             *AND ACCNTAB/RETB *NE X"02" *AND ACCNTAB/RETB *NE +
                             X"04" *AND  ACCNTAB/RETB *NE X"40" *AND ACCNTAB/RETB +
                             *NE X"42" *AND ACCNTAB/RETB *NE X"44" *AND  +
                             ACCNTAB/RETB *NE X"80" *AND ACCNTAB/RETB *NE X"82" +
                             *AND ACCNTAB/RETB *NE X"84" *AND  ACCNTAB/RETB *NE +
                             X"C0" *AND ACCNTAB/RETB *NE X"C2" *AND ACCNTAB/RETB +
                             *NE X"C4")') KEYFLD((ACCNTAB/BRCA) (CLINTCB/ACOC) +
                             (ACCNTAB/CCY) (ACCNTAB/CNUM) (ACCNTAB/ACOD) +
                             (ACCNTAB/ACSQ)) JFLD((ACCNTAB/CNUM CLINTCB/CNUM)) +
                             MAPFLD((RECI 'ACCNTAB/RECI') (BRCA 'ACCNTAB/BRCA') +
                             (CNUM 'ACCNTAB/CNUM') (CCY 'ACCNTAB/CCY') (ACOD +
                             'ACCNTAB/ACOD') (ACSQ 'ACCNTAB/ACSQ') (ACNO +
                             'ACCNTAB/ACNO') (CRNM 'CLINTCB/CRNM') (GRBL +
                             'ACCNTAB/LDBL') (NETB 'ACCNTAB/CLBL') (LACD +
                             'ACCNTAB/LACD') (RETB 'ACCNTAB/RETB') (ACOC +
                             'CLINTCB/ACOC') (ZZ009 '%SST(ZZ024 1 9)' *CHAR 9)) +
                             IGNDECERR(*YES)                                            /*AR945431*/

             ENDDO                                                                      /*AR945431*/
/*/COPY WNCPYSRC,REC3872002                                          */
             ENDDO
/**/
             ELSE       CMD(DO)
/*/COPY WNCPYSRC,REC3872003                                          */

   IF         COND(&NONRETL *NE 'Y')    THEN(DO)                                        /*AR945431*/

             OPNQRYF    FILE((ACCNTAB) (CLINTCB)) FORMAT(IBPAIB) +
                          QRYSLT('(ACCNTAB/RECI *EQ "D" *AND +
                          ACCNTAB/ATYP *EQ "R" *AND ACCNTAB/RETB *NE +
                          X"00" *AND ACCNTAB/RETB *NE X"02" *AND +
                          ACCNTAB/RETB *NE X"04" *AND  ACCNTAB/RETB +
                          *NE X"40" *AND ACCNTAB/RETB *NE X"42" *AND +
                          ACCNTAB/RETB *NE X"44" *AND  ACCNTAB/RETB +
                          *NE X"80" *AND ACCNTAB/RETB *NE X"82" *AND +
                          ACCNTAB/RETB *NE X"84" *AND  ACCNTAB/RETB +
                          *NE X"C0" *AND ACCNTAB/RETB *NE X"C2" *AND +
                          ACCNTAB/RETB *NE X"C4")') +
                          KEYFLD((ACCNTAB/BRCA) (CLINTCB/ACOC) +
                          (ACCNTAB/CCY) (ACCNTAB/CNUM) (ACCNTAB/ACOD) +
                          (ACCNTAB/ACSQ)) JFLD((ACCNTAB/CNUM +
                          CLINTCB/CNUM)) MAPFLD((RECI 'ACCNTAB/RECI') +
                          (BRCA 'ACCNTAB/BRCA') (CNUM 'ACCNTAB/CNUM') +
                          (CCY 'ACCNTAB/CCY') (ACOD 'ACCNTAB/ACOD') +
                          (ACSQ 'ACCNTAB/ACSQ') (ACNO 'ACCNTAB/ACNO') +
                          (CRNM 'CLINTCB/CRNM') (GRBL 'ACCNTAB/LDBL') +
                          (NETB 'ACCNTAB/CLBL') (LACD 'ACCNTAB/LACD') +
                          (RETB 'ACCNTAB/RETB') (ACOC 'CLINTCB/ACOC') +
                          (ZZ009 '%SST(ZZ024 1 9)' *CHAR 9)) +
                          IGNDECERR(*YES)
   ENDDO                                                                                /*AR945431*/
             ELSE       CMD(DO)                                                         /*AR945431*/

                OPNQRYF    FILE((ACCNTAB) (CLINTCB)) FORMAT(IBPAIB) +
                             QRYSLT('(ACCNTAB/RECI *EQ "D" *AND ACCNTAB/RETB *NE +
                             X"00" *AND ACCNTAB/RETB *NE X"02" *AND ACCNTAB/RETB +
                             *NE X"04" *AND  ACCNTAB/RETB *NE X"40" *AND +
                             ACCNTAB/RETB *NE X"42" *AND ACCNTAB/RETB *NE X"44" +
                             *AND  ACCNTAB/RETB *NE X"80" *AND ACCNTAB/RETB *NE +
                             X"82" *AND ACCNTAB/RETB *NE X"84" *AND  ACCNTAB/RETB +
                             *NE X"C0" *AND ACCNTAB/RETB *NE X"C2" *AND +
                             ACCNTAB/RETB *NE X"C4")') KEYFLD((ACCNTAB/BRCA) +
                             (CLINTCB/ACOC) (ACCNTAB/CCY) (ACCNTAB/CNUM) +
                             (ACCNTAB/ACOD) (ACCNTAB/ACSQ)) JFLD((ACCNTAB/CNUM +
                             CLINTCB/CNUM)) MAPFLD((RECI 'ACCNTAB/RECI') (BRCA +
                             'ACCNTAB/BRCA') (CNUM 'ACCNTAB/CNUM') (CCY +
                             'ACCNTAB/CCY') (ACOD 'ACCNTAB/ACOD') (ACSQ +
                             'ACCNTAB/ACSQ') (ACNO 'ACCNTAB/ACNO') (CRNM +
                             'CLINTCB/CRNM') (GRBL 'ACCNTAB/LDBL') (NETB +
                             'ACCNTAB/CLBL') (LACD 'ACCNTAB/LACD') (RETB +
                             'ACCNTAB/RETB') (ACOC 'CLINTCB/ACOC') (ZZ009 +
                             '%SST(ZZ024 1 9)' *CHAR 9)) IGNDECERR(*YES)                /*AR945431*/
             ENDDO                                                                      /*AR945431*/

/*/COPY WNCPYSRC,REC3872004                                          */
             ENDDO
/**/
                CALL       PGM(RE3872) PARM(&RSEQ &RENT)
                CLOF       OPNID(ACCNTAB)
/**/
                IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                   RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)
                   CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
/**/
                   SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)  +
                             TOMSGQ(MOPERQ MRUNQ)
                ENDDO
/**/
                RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
END:         ENDPGM
