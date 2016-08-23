/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE REPYMENT ANOMALIES, EXTRCT & RPT')           */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0709 - REPAYMENT ANOMALIES, EXTRACT AND REPORT          */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. BHF798              DATE  09OCT90           */
/*       PREV AMEND NO. BHF742              DATE  02OCT90           */
/*                      S01194              DATE  07FEB90           */
/*                      S01117              DATE  07FEB90           */
/*                                                                  */
/********************************************************************/
/*       BHF798 - CLOF ALL OPNDBF AT END OF PGM                     */
/*       BHF742 - SHOULD CLOSE FILE OPENED TO CHECK FILE POSITIONING*/
/*       S01194 - NEW STANDING DATA                                 */
/*       S01117 - REL.10 MULTIBRANCHING                             */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                     * *S01117*/
             PGM PARM(&RSEQ &RLEV &RENT)                              /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                          VALUE('REPAYMENT ANOMALIES ,EXTRACT AND +
                          REPORT')
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(MATEXHH)
             CLRPFM     FILE(MATEXEL)
             CLRPFM     FILE(MATEXZZ)
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)             */    /*S01194*/
/**/
             CALL       PGM(LE0570)
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/***************CALL       PGM(LE0580)                           */   /*S01117*/
/* POSITION FILE TO THE PARTICULAR ENTITY                            * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(MATSR) POSITION(*KEY 1 LVENTELF +
                           &RENT)                                     /*S01117*/
                 OPNDBF    FILE(MATSR) OPTION(*ALL)                   /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(MATSR)                           /*S01117*/
                 ENDDO                                                /*S01117*/
             CLOF       OPNID(MATSR)                                  /*BHF742*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             ENDDO                                                    /*S01117*/
                CALL       PGM(LE0580) PARM(&RSEQ &RENT)              /*S01117*/
/**/
                IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
                   CLRPFM     FILE(MATEXHH)
                   CLRPFM     FILE(MATEXEL)
                   CLRPFM     FILE(MATEXZZ)
                ENDDO
/**/
             ENDDO
             CLOF       OPNID(MATSR)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
