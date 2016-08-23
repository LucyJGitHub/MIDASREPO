/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE OUTSTNDING DELIVERY INSTRUCTIONS')           */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0707 -OUTSTANDING DELIVERY INSTRUCTIONS                 */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01194              DATE  11DEC89           */
/*       PREV AMEND NO. S01117              DATE  11DEC89           */
/*                                                                  */
/********************************************************************/
/*       S01194 - NEW STANDING DATA                                 */
/*       S01117 - REL.10 MULTIBRANCHING                             */
/********************************************************************/
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
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('OUTSTANDING DELIVERY INSTRUCTIONS')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
/*PRINT                                                             */
             CHGJOB     SWS(XXXXXX00)
/************OVRDBF     FILE(TABLE) TOFILE(TABLEEE)           */      /*S01194*/
/**/
/************CALL       PGM(LE0620)                               */  /*S01117*/
/* POSITION FILE TO THE PARTICULAR ENTITY                            * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(LVEDE) POSITION(*KEY 1 LVENTELF +
                           &RENT)                                     /*S01117*/
                 OPNDBF    FILE(LVEDE) OPTION(*ALL)                   /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(LVEDE)                           /*S01117*/
                 ENDDO                                                /*S01117*/
             ENDDO                                                    /*S01117*/
             CALL       PGM(LE0620) PARM(&RSEQ &RENT)                 /*S01117*/
/**/
/************DLTOVR     FILE(TABLE)                     */            /*S01194*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
