/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE COMMTMT SUMMRY BY CTRY AND REGN')            */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC1006 - COMMITMENT SUMMARY BY COUNTRY AND REGION         */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01339          DATE 09APR92                */
/*       PREV AMEND NO. BHF798          DATE 09OCT90                */
/*                      BHF742          DATE 02OCT90                */
/*                      S01194          DATE 09FEB90                */
/*                      S01117          DATE 09FEB90                */
/*                      S01179          DATE 14/09/88               */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       S01339 - REMOVE SYNDICATED LOANS PROCESSING, DUE TO        */
/*                MODULE REDUNDANCY.                                */
/*       BHF798 - CLOF ALL OPNDBF AT END OF PGM                     */
/*       BHF742 - SHOULD CLOSE FILE OPENED TO CHECK FILE POSITIONING*/
/*       S01194 - NEW STANDING DATA                                 */
/*       S01117 - RELEASE 10 MULTIBRANCHING                         */
/*       S01179 - AS400 INCORPORATION                               */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                     * *S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/**/
/*********** DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
             DCL VAR(&MMOD) TYPE(*CHAR) LEN(256)
/**/
             SNDPGMMSG  MSG('COMMITMENT SUMMARY BY COUNTRY AND REGION +
                             REPORT') TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(COMEXHH)
             CLRPFM     FILE(COMEXCF)
             CLRPFM     FILE(COMEXZZ)
/**/
/**CHECK*FOR*COMMERCIAL*LOANS*MODULE*PRESENT***********/     /*S01339*/
/**/                                                         /*S01339*/
/************RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)  ***/     /*S01339*/
/************IF      COND(%SST(&MMOD 4 1)=Y) THEN(CHGJOB **/ /*S01339*/
/************************SWS(1XXXXXXX))     *************/   /*S01339*/
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)                  * *S01194*/
             CALL       PGM(LE0980)
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/************** CALL       PGM(LE0990)                               * *S01117*/
/* POSITION FILE TO THE PARTICULAR ENTITY                            * *S01117*/
             IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) +
             THEN(DO)                                                 /*S01117*/
                 OVRDBF    FILE(SCOMX) POSITION(*KEY 1 COMEXCFF +
                           &RENT)                                     /*S01117*/
                 OPNDBF    FILE(SCOMX) OPTION(*ALL)                   /*S01117*/
                 MONMSG    MSGID(CPF0000) EXEC(DO)                    /*S01117*/
                     DLTOVR     FILE(SCOMX)                           /*S01117*/
                 ENDDO                                                /*S01117*/
             CLOF       OPNID(SCOMX)                                  /*BHF742*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
             ENDDO                                                    /*S01117*/
                CALL       PGM(LE0990) PARM(&RSEQ &RENT)              /*S01117*/
/**/
                CLRPFM     FILE(COMEXHH)
                CLRPFM     FILE(COMEXCF)
                CLRPFM     FILE(COMEXZZ)
/**/
             ENDDO
             CLOF       OPNID(SCOMX)                                  /*BHF798*/
             MONMSG     MSGID(CPF0000)                                /*BHF798*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
