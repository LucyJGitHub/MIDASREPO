/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Events generation')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas      FUNDS TRANSFER MODULE                            */
/*                                                                   */
/*       FTC0610    EVENTS GENERATION                                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 02Oct96              */
/*                      S01117             Date 08May91              */
/*                      S01194         DATE  08MAY91                 */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*    S01408 - Addition of Core Hook FTC0610002                      */
/*             Addition of Core Hook FTC0610001                      */
/*    S01117 - RELEASE 10 MULTIBRANCHING CHANGES                     */
/*    S01194 - NEW DATABASE HANDLING                                 */
/*                                                                   */
/*********************************************************************/
            PGM
/*/COPY WNCPYSRC,FTC0610004                                          */
/**         DCL     VAR(&DATA) TYPE(*CHAR) LEN(44)                    /*S01194*/
            DCL     VAR(&DATA) TYPE(*CHAR) LEN(50)                    /*S01194*/
/**/                                                                  /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,FTC0610003                                          */
/**/                                                                  /*S01117*/
/**/
/**/
            SNDPGMMSG  MSG('FT0610 - Events Generation') TOMSGQ(MRUNQ)
/**/
/**/
            CLRPFM FILE(FPVNTDD)
            CLRPFM FILE(FPVNTZZ)
/**/
            CHGJOB SWS(XXXXXX00)
/**/
/*                                                              */
/*/COPY WNCPYSRC,FTC0610001                                     */
/*                                                              */
            CALL PGM(FT0610)
/*                                                              */
/*/COPY WNCPYSRC,FTC0610002                                     */
/*                                                              */
/**/
/** .. CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**             RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DATA)         /*S01194*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01194*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
/** .. CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM    **/
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDPGMMSG MSG('FILE CONTROLS OUT OF BALANCE') +
                             TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
            ENDPGM
