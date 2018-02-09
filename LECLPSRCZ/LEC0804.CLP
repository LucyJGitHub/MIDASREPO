/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Collateral by Loan')                         */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0804 - COLLATERAL BY LOAN REPORT                         */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 193219             Date 31May01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      BHF798             Date 02May91              */
/*                      S01194             Date 07Feb90              */
/*                      S01117              DATE  07FEB90           */
/*                      S01179              DATE  14/09/88          */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       193219 - Component LEC08 Seq. No. 10006 failed in COB.      */
/*                Execute line CLOF OPNID(SGSCX) for single branch   */
/*                request.                                           */
/*       BHF798 - CLOF ALL OPNDBF AT END OF PGM                     */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01117 - REL.10 MULTIBRANCHING                             */
/*       S01179 - AS400 INCORPORATION                               */
/********************************************************************/
/*********** PGM                                                     * *S01117*/
             PGM PARM(&RSEQ &RLEV &RENT)                              /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/**/
/************DCLDTAARA  DTAARA(LESTAT)                              *  *S01179*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                          VALUE('COLLATERAL BY LOAN REPORT')
             DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&OPNIND) TYPE(*CHAR) LEN(1) VALUE('0')                        /*193219*/
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
/************** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)      */        /*S01194*/
                CALL       PGM(LE0780)
/************** DLTOVR     FILE(TABLE)                      */        /*S01194*/
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
/****************  OVRDBF     FILE(TABLE) TOFILE(TABLEEE)    */       /*S01194*/
/***************** CALL       PGM(LE0790)                  */         /*S01117*/
/* POSITION FILE TO THE PARTICULAR ENTITY                            * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(SGSCX) POSITION(*KEY 1 GSCEXGGF +
                           &RENT)                                     /*S01117*/
                 OPNDBF    FILE(SGSCX) OPTION(*ALL)                   /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(SGSCX)                           /*S01117*/
                     CHGVAR     VAR(&OPNIND) VALUE('1')                                   /*193219*/
                 ENDDO                                                /*S01117*/
             ENDDO                                                    /*S01117*/
                   CALL       PGM(LE0790) PARM(&RSEQ &RENT)           /*S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL') +
             *AND (&OPNIND *NE '1')) THEN(DO)                                             /*193219*/
                 CLOF      OPNID(SGSCX)                                                   /*193219*/
                 MONMSG    MSGID(CPF0000)                                                 /*193219*/
             ENDDO                                                                        /*193219*/
/***************** DLTOVR     FILE(TABLE)                    */       /*S01194*/
/**/
ENDDO04:        ENDDO
/**/
ENDDO03:     ENDDO
/**********  CLOF       OPNID(SGSCX) */                                            /*BHF798 193219*/
/**********  MONMSG     MSGID(CPF0000) */                                          /*BHF798 193219*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
