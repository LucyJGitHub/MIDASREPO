/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE LOAN INCOME & AVG. BY CUST REPORTS')         */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC1004C - PRINT LOAN INCOME AND AVERAGES BY CUSTOMER      */
/*                                                                  */
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
/*       LAST AMEND NO. BHF742                  DATE  02OCT90       */
/*                      S01117             Date 09Feb90              */
/*                      S01194                  DATE  09FEB90       */
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
             SNDPGMMSG  MSG('LOAN INCOME AND AVERAGES BY CUSTOMER +
                             REPORT') TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(AVRGEHH)
             CLRPFM     FILE(AVRGEAY)
             CLRPFM     FILE(AVRGEZY)
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)                  * *S01194*/
/*********** OVRDBF     FILE(TABLED) TOFILE(TABLEEE) SHARE(*NO)      * *S01194*/
             CALL       PGM(LE0940)
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/*********** CALL       PGM(LE0950)                                  * *S01117*/
/* POSITION FILE TO THE PARTICULAR ENTITY                            * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(SAVRG) POSITION(*KEY 1 AVRGEAYF +
                           &RENT)                                     /*S01117*/
                 OPNDBF    FILE(SAVRG) OPTION(*ALL)                   /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(SAVRG)                           /*S01117*/
                 ENDDO                                                /*S01117*/
             CLOF       OPNID(SAVRG)                                  /*BHF742*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             ENDDO                                                    /*S01117*/
             CALL       PGM(LE0950) PARM(&RSEQ &RENT)                 /*S01117*/
/**/
                CLRPFM     FILE(AVRGEHH)
                CLRPFM     FILE(AVRGEAY)
                CLRPFM     FILE(AVRGEZY)
/**/
             ENDDO
/**/
/*********** DLTOVR     FILE(*ALL)                                   * *S01194*/
             CLOF       OPNID(SAVRG)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
