/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE INACTIVE AND BLOCKED A/C'S REPORT')          */
/*********************************************************************/
/*                                                                   */
/*       Midas       Retail Module                               */
/*                                                                   */
/*       REC3872 - INACTIVE AND BLOCKED ACCOUNTS REPORT              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
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
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/
             SNDPGMMSG  MSG('REC3872 - Inactive & Blocked Accounts +
                          Report') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**/
             OVRDBF     SIBP ACCNTAB SHARE(*YES)
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                          THEN(DO)
/*/COPY WNCPYSRC,REC3872001                                          */
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
/*/COPY WNCPYSRC,REC3872002                                          */
             ENDDO
/**/
             ELSE       CMD(DO)
/*/COPY WNCPYSRC,REC3872003                                          */
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
                          Misys International Banking Systems Ltd.')
END:         ENDPGM
