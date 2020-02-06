/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Inactive & blocked accounts report')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                               */
/*                                                                   */
/*       REC0872  - INACTIVE AND BLOCKED ACCOUNTS REPORT             */
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
/*       PREV AMEND NO. S01413             DATE 13APR93              */
/*                      LN0316                  28JUN90              */
/*                      LN0139                  09MAY90              */
/*                      S01117                  16MAR90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01413  - Retail 3 Incorporation.                           */
/*       LN0316  - Program tries to delete an override that          */
/*                 has already been deleted.                         */
/*       LN0139  - Amendment to key position in OVRDBF for RCF       */
/*       S01117  - Multibranching                                    */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                      /*S01117*/
             PGM     PARM(&RSEQ &RLEV &RENT)                          /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL     VAR(&RSEQ) TYPE(*CHAR) LEN(5)                    /*S01117*/
             DCL     VAR(&RLEV) TYPE(*CHAR) LEN(1)                    /*S01117*/
             DCL     VAR(&RENT) TYPE(*CHAR) LEN(3)                    /*S01117*/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01117*/
             DCL     VAR(&LDA) TYPE(*CHAR) LEN(256)                   /*S01117*/
/**/
             SNDPGMMSG  MSG('REC0872 - Inactive & Blocked Accounts +
                          Report') TOMSGQ(MRUNQ)
/**/
/***************CHGJOB SWS(11000000) */                               /*S01413*/
                CHGJOB SWS(10000000)                                  /*S01413*/
/**/
/***************OVRDBF FILE(TABLE) TOFILE(TABRE2) */                  /*S01413*/
/**/
/*              IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +               */
/*                 THEN(OVRDBF FILE(SIBP) POSITION(*KEY 1 +                   */
/*                 IBPAIBF &RENT)                                     /*S01117*/
                OVRDBF     FILE(SIBP) TOFILE(ACCNTAB) SHARE(*YES)     /*S01413*/
                IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                   THEN(DO)                                           /*S01117*/
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
                          *CHAR 9)) IGNDECERR(*YES) /*S01413*/
             ENDDO                                                    /*S01413*/
/*************     OVRDBF FILE(SIBP) POSITION(*KEY 1 +
/*************     IBPAIBF &RENT)                            /*S01117  *LN0139*/
/******************OVRDBF FILE(SIBP) POSITION(*KEY 2 +
                   IBPAIBF &RENT) */                       /*LN0139*/ /*S01413*/
/******************OPNDBF FILE(SIBP) OPTION(*ALL) */       /*S01117*/ /*S01413*/
/******************MONMSG MSGID(CPF0000) EXEC(DO) */       /*S01117*/ /*S01413*/
/******************DLTOVR FILE(SIBP) */                    /*S01117*/ /*S01413*/
/******************ENDDO */                                /*S01117*/ /*S01413*/
             ELSE       CMD(DO)                                       /*S01413*/
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
                          IGNDECERR(*YES)                             /*S01413*/
                   ENDDO                                              /*S01117*/
/***********    CALL PGM(RE0872)                                      /*S01117*/
/***************CALL PGM(RE0872)   PARM(&RSEQ &RENT) */    /*S01117*/ /*S01413*/
                CALL       PGM(RE3872) PARM(&RSEQ &RENT)              /*S01413*/
                CLOF       OPNID(ACCNTAB)                             /*S01413*/
/**/
/***************IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                      THEN(DO) */                          /*LN0316*/ /*S01413*/
/*                 THEN(DLTOVR FILE(SIBP))                     *S01117**LN0316*/
/*********************DLTOVR FILE(SIBP) */                 /*LN0316*/ /*S01413*/
/*********************MONMSG MSGID(CPF9841) */             /*LN0316*/ /*S01413*/
/******************ENDDO */                                /*LN0316*/ /*S01413*/
/**/
/***************DLTOVR FILE(TABLE) */                                 /*S01413*/
/**/
                IF COND(%SWITCH(XXXXXX1X)) THEN(DO)                   /*S01117*/
                   RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)            /*S01117*/
                   CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))          /*S01117*/
/**/                                                                  /*S01117*/
                   SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)  +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01117*/
                ENDDO                                                 /*S01117*/
/***************ELSE CMD(DO) */                            /*S01117*/ /*S01413*/
/**/
/***************IF         COND(%SWITCH(XXXXXXX1)) THEN(DO) */        /*S01413*/
/******************SNDPGMMSG  MSG('FILE OUT OF BALANCE - RE0872') +
                          TOMSGQ(MRUNQ MOPERQ) */                     /*S01413*/
/***************ENDDO */                                              /*S01413*/
/**/
/***************ENDDO */                                   /*S01117*/ /*S01413*/
/**/
                RCLRSC                                                /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
END:         ENDPGM
