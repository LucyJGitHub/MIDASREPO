/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Retail advices print')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                                   */
/*                                                                   */
/*       REC78 - RETAIL ADVICES PRINT                                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CRE020             Date 20Jan04              */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 115787             Date 04Sep97              */
/*                      S01408             DATE 21Sep95              */
/*                      S01413             DATE 13APR93              */
/*                      E19060             DATE 09AUG89              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       115787 - Include Historic Deals.                            */
/*       S01408 - Addition of Core Hook REC78INT                     */
/*                Addition of Core Hook REC78001                     */
/*                Addition of Core Hook REC78002                     */
/*                Addition of Core Hook REC78003                     */
/*       S01413 - Header Box Standardised                            */
/*       E19060 - reinsertion of 'ALCOBJ' and 'DLCOBJ' commands      */
/*                for error no. 11699                                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM
                                                                                          /*CRE020*/
/* Declare the variables to check the enhancements file */                                /*CRE020*/
                                                                                          /*CRE020*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                   /*CRE020*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                                                /*CRE020*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CRE020*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CRE020*/
                                                                                          /*CRE020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*/                                                                  */
/*/COPY WNCPYSRC,REC78INT                                            */
/*/                                                                  */
                                                                                          /*CRE020*/
/* Check if enhancement CRE020 in installed */                                            /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&SARD) VALUE('CRE020')                                        /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE &OPTN &SARD &FMT)                      /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTNCDE *NE '       ' *AND &RTNCDE *NE +
                          '*NRF   ') THEN(DO)                                             /*CRE020*/
             SNDPGMMSG  MSG('DATABASE IN ERROR - SCSARDPD') TOMSGQ(MOPERQ)                /*CRE020*/
             GOTO       CMDLBL(END)                                                       /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTNCDE *EQ '       ') THEN(GOTO CMDLBL(END))                /*CRE020*/
                                                                                          /*CRE020*/
             SNDPGMMSG MSG('REC78 - Retail Advices Print') TOMSGQ(MRUNQ)
/**/
             CHGJOB SWS(11111000)
/**/
/*/COPY WNCPYSRC,REC78001                                            */
/*/                                                                  */
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
             OVRDBF FILE(DEALALL) TOFILE(DEALSALL)                    /*115787*/
/**/
             ALCOBJ OBJ((ACCNT *FILE *EXCLRD)) WAIT(9999)             /*E19060*/
/**/
/*/COPY WNCPYSRC,REC78002                                            */
/*/                                                                  */
             CALL PGM(RE0782)
/**/
             DLCOBJ OBJ((ACCNT *FILE *EXCLRD))                        /*E19060*/
/*/COPY WNCPYSRC,REC78004                                            */
/**/
             DLTOVR FILE(DEALALL)                                     /*115787*/
             DLTOVR FILE(TABLE)
/**/
             CHGJOB SWS(00000XXX)
/**/
/*/COPY WNCPYSRC,REC78003                                            */
/*/                                                                  */
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
               IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
/*/COPY WNCPYSRC,REC78005                                            */
                  SNDPGMMSG MSG('FILE OUT OF BALANCE - RE0782') TOMSGQ(MOPERQ)
/*/COPY WNCPYSRC,REC78006                                            */
               ENDDO
               IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
/*/COPY WNCPYSRC,REC78007                                            */
                  SNDPGMMSG MSG('DATABASE IN ERROR - RE0782') TOMSGQ(MOPERQ)
/*/COPY WNCPYSRC,REC78008                                            */
               ENDDO
             ENDDO
/**/
END:                                                                                      /*CRE020*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
