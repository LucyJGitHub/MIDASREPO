/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE LOANS OUTSTANDING BY GUARANTOR')             */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0805 - LOANS OUTSTANDING BY GUARANTOR REPORT           */
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
/*       PREV AMEND NO. BHF798              DATE  09OCT90           */
/*                      S01194              DATE  07FEB90           */
/*                      S01117              DATE  07FEB90           */
/*                      S01179              DATE  14/09/88          */
/*                                                                  */
/********************************************************************/
/*       E40440 - ALLOW CALL IF LEVEL IS BLANK                      */
/*       BHF798 - CLOF ALL OPNDBF AT END OF PGM                     */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01117 - REL.10 MULTIBRANCHING                             */
/*       S01179 - AS400 INCORPORATION                               */
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
/*********** DCLDTAARA  DTAARA(LESTAT)                              *  *S01179*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                          VALUE('LOANS OUTSTANDING BY +
                          GUARANTOR REPORT')
             DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
             ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))
             RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
/**/
/* CREATE EXTRACT IF NOT ALREADY CREATED */
/**/
DO01:        IF         COND(%SUBSTRING(&LESTAT 17 1) *NE Y) +
                        THEN(DO)
/**/
                CLRPFM     FILE(GSCEXHH)
                CLRPFM     FILE(GSCEXGG)
                CLRPFM     FILE(GSCEXT2)
/**/
/************** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)   */           /*S01194*/
                CALL       PGM(LE0780)
/************** DLTOVR     FILE(TABLE)                   */           /*S01194*/
/**/
DO02:           IF         COND(%SWITCH(XXXXXXX0))  +
                           THEN(DO)
/**/
/***************** CHANGE DTAARA TO 'Y' */
                   CHGVAR     VAR(%SUBSTRING(&LESTAT 17 1)) VALUE('Y')
             CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)
/**/
ENDDO02:        ENDDO
/**/
ENDDO01:     ENDDO
/**/
             DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))
/**/
/* REPORT PROGRAM */
/**/
DO03:        IF         COND(%SWITCH(XXXXXXX0))  +
                           THEN(DO)
/**/
                RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
DO04:           IF         COND(%SUBSTRING(&LESTAT 17 1) *EQ Y) +
                           THEN(DO)
/**/
/***************** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)  */         /*S01194*/
/***************** CALL       PGM(LE0810)                  */         /*S01117*/
/******IF*******  COND(&RLEV *EQ 'S') THEN(DO)              /*S01117*  *E40440*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(DO)                                    /*E40440*/
                          CALL    PGM(LE0810) PARM(&RSEQ)             /*S01117*/
             ENDDO                                                    /*S01117*/
             IF         COND(&RLEV *EQ 'C') THEN(DO)                  /*S01117*/
/* POSITION FILE TO THE PARTICULAR COMPANY                           * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(SGLNSL2) POSITION(*KEY 1 GSCEXGGF +
                           &RENT)                                     /*S01117*/
                 OPNDBF    FILE(SGLNSL2) OPTION(*ALL)                 /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(SGLNSL2)                         /*S01117*/
                 ENDDO                                                /*S01117*/
             ENDDO                                                    /*S01117*/
                          CALL    PGM(LE0812) PARM(&RSEQ &RENT)       /*S01117*/
             ENDDO                                                    /*S01117*/
             IF         COND(&RLEV *EQ 'B') THEN(DO)                  /*S01117*/
/* POSITION FILE TO THE PARTICULAR BRANCH                            * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(SGLNSL1) POSITION(*KEY 1 GSCEXGGF +
                           &RENT)                                     /*S01117*/
                 OPNDBF    FILE(SGLNSL1) OPTION(*ALL)                 /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(SGLNSL1)                         /*S01117*/
                 ENDDO                                                /*S01117*/
             ENDDO                                                    /*S01117*/
                          CALL    PGM(LE0811) PARM(&RSEQ &RENT)       /*S01117*/
             ENDDO                                                    /*S01117*/
/***************** DLTOVR     FILE(TABLE)                  */         /*S01194*/
/**/
ENDDO04:        ENDDO
/**/
ENDDO03:     ENDDO
             CLOF       OPNID(SGLNSL2)                                /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             CLOF       OPNID(SGLNSL1)                                /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
