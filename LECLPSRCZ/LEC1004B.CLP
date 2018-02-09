/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE PRINT YEAR-TO-DATE REPORTS')                 */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*    LEC1004B - PRINT YEAR-TO-DATE WITHHOLDING TAX AND INTEREST ,  */
/*                                  PLUS PROJECTED TO YEAR END      */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. BHF798             Date 09Oct90              */
/*                      BHF742             Date 02Oct90              */
/*                      S01117        DATE  09FEB90                 */
/*                      S01194        DATE  09FEB90                 */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       BHF798 - CLOF ALL OPNDBF AT END OF PGM                     */
/*       BHF742 - SHOULD CLOSE FILE OPENED TO CHECK FILE POSITIONING*/
/*       S01117 - RELEASE 10 MULTIBRANCHING                         */
/*       S01194 - NEW STANDING DATA                                 */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                     * *S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/**/
             SNDPGMMSG  MSG('PRINT YEAR-TO-DATE REPORTS') TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(TAXEXHH)
             CLRPFM     FILE(TAXEXWT)
             CLRPFM     FILE(TAXEXZX)
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)                  * *S01194*/
/*********** OVRDBF     FILE(TABLED) TOFILE(TABLEEE) SHARE(*NO)      * *S01194*/
             CALL       PGM(LE0920)
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/************** CALL       PGM(LE0930)                               * *S01117*/
/* POSITION FILE TO THE PARTICULAR ENTITY                            * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(STAXX) POSITION(*KEY 1 TAXEXWTF +
                           &RENT)                                     /*S01117*/
                 OPNDBF    FILE(STAXX) OPTION(*ALL)                   /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(STAXX)                           /*S01117*/
                 ENDDO                                                /*S01117*/
             CLOF       OPNID(STAXX)                                  /*BHF742*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             ENDDO                                                    /*S01117*/
                CALL       PGM(LE0930) PARM(&RSEQ &RENT)              /*S01117*/
/**/
                CLRPFM     FILE(TAXEXHH)
                CLRPFM     FILE(TAXEXWT)
                CLRPFM     FILE(TAXEXZX)
/**/
             ENDDO
             CLOF       OPNID(STAXX)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
