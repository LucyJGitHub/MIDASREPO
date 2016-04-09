/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE COMMITMENT FEES ACCRUALS REPORT')            */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0807 - CUSTOMER LENDING COMMITMENT FEES ACCRUAL REPORT  */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E40440            DATE  05AUG92             */
/*       PERV AMEND NO. BHF798              DATE  09OCT90           */
/*                      BHF742              DATE  02OCT90           */
/*                      S01194              DATE  07FEB90           */
/*                      S01117              DATE  07FEB90           */
/*                                                                  */
/********************************************************************/
/*       E40440 - ALLOW CALL IF LEVEL IS BLANK                      */
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
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             SNDPGMMSG  MSG('COMMITMENT FEES ACCRUAL REPORT') +
                        TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(CFCLTHH)
             CLRPFM     FILE(CFCLTAC)
             CLRPFM     FILE(CFCLTZZ)
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE) SHARE(*NO)*/      /*S01194*/
             CALL       PGM(LE1130)
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/**/
/************ OVRDBF     FILE(TABLED) TOFILE(TABLEEE) SHARE(*NO)*/    /*S01194*/
/************** CALL       PGM(LE1140)                      */        /*S01117*/
/******IF*******  COND(&RLEV *EQ 'S') THEN(DO)              /*S01117*  *E40440*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(DO)                                    /*E40440*/
/**************       CALL    PGM(LE1142)                             /*S01117*/
                      CALL    PGM(LE1142) PARM(&RSEQ)                 /*S01117*/
                   ENDDO                                              /*S01117*/
                   IF         COND(&RLEV *EQ 'C') THEN(DO)            /*S01117*/
/* POSITION FILE TO THE PARTICULAR COMPANY                           * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(SCFCLL1) POSITION(*KEY 1 CFCLTACF +
                           &RENT)                                     /*S01117*/
                 OPNDBF    FILE(SCFCLL1) OPTION(*ALL)                 /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(SCFCLL1)                         /*S01117*/
                 ENDDO                                                /*S01117*/
             CLOF       OPNID(SCFCLL1)                                /*BHF742*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             ENDDO                                                    /*S01117*/
                      CALL    PGM(LE1141) PARM(&RSEQ &RENT)           /*S01117*/
                   ENDDO                                              /*S01117*/
                   IF         COND(&RLEV *EQ 'B') THEN(DO)            /*S01117*/
/* POSITION FILE TO THE PARTICULAR BRANCH                            * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(SCFCL) POSITION(*KEY 1 CFCLTACF +
                           &RENT)                                     /*S01117*/
                 OPNDBF    FILE(SCFCL) OPTION(*ALL)                   /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(SCFCL)                           /*S01117*/
                 ENDDO                                                /*S01117*/
             CLOF       OPNID(SCFCL)                                  /*BHF742*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             ENDDO                                                    /*S01117*/
                      CALL    PGM(LE1140) PARM(&RSEQ &RENT)           /*S01117*/
                   ENDDO                                              /*S01117*/
/**/
                CLRPFM     FILE(CFCLTHH)
                CLRPFM     FILE(CFCLTAC)
                CLRPFM     FILE(CFCLTZZ)
/**/
             ENDDO
/**/
/*********** DLTOVR     FILE(*ALL)                        */          /*S01194*/
             CLOF       OPNID(SCFCLL1)                                /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             CLOF       OPNID(SCFCL)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
