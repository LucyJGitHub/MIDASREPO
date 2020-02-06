/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE LOANS OUTSTANDING BY INDUSTRY')              */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC1008 - LOANS OUTSTANDING BY INDUSTRY REPORT             */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      BHF798             Date 09Oct90              */
/*                      BHF742          Date 02Oct90                */
/*                      S01194          DATE 09FEB90                */
/*                      S01117          DATE 09FEB90                */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       BHF798 - CLOF ALL OPNDBF AT END OF PGM                     */
/*       BHF742 - SHOULD CLOSE FILE OPENED TO CHECK FILE POSITIONING*/
/*       S01194  -  NEW STANDING DATA                               */
/*       S01117  -  RELEASE 10 MULTIBRANCHING                       */
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
             SNDPGMMSG  MSG('LOANS OUTSTANDING BY INDUSTRY REPORT') +
                        TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(INDUSHH)
             CLRPFM     FILE(INDUSIN)
             CLRPFM     FILE(INDUSZZ)
 
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)                  * *S01194*/
             OVRDBF     FILE(CLOANC) TOFILE(CLOAN) SHARE(*NO)
             CALL       PGM(LE1030)
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/*********** OVRDBF     FILE(TABLED) TOFILE(TABLEEE) SHARE(*NO)      * *S01194*/
/************** CALL       PGM(LE1040)                               * *S01117*/
/* POSITION FILE TO THE PARTICULAR ENTITY                            * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(SINDU) POSITION(*KEY 1 INDUSINF +
                           &RENT)                                     /*S01117*/
                 OPNDBF    FILE(SINDU) OPTION(*ALL)                   /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(SINDU)                           /*S01117*/
                 ENDDO                                                /*S01117*/
             CLOF       OPNID(SINDU)                                  /*BHF742*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             ENDDO                                                    /*S01117*/
                CALL       PGM(LE1040) PARM(&RSEQ &RENT)              /*S01117*/
/**/
                CLRPFM     FILE(INDUSHH)
                CLRPFM     FILE(INDUSIN)
                CLRPFM     FILE(INDUSZZ)
/**/
             ENDDO
/**/
/*********** DLTOVR     FILE(*ALL)                                   * *S01194*/
             CLOF       OPNID(SINDU)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
