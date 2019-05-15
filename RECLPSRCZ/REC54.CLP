/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE ICD by CCY Listing')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas       Retail Module                               */
/*                                                                   */
/*       REC54  RETAIL ICD BY CURRENCY LISTING                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01413             Date 13Apr93              */
/*                                         Date                      */
/*                      S01117                  17APR90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01413 - Retail 3 Incorporation                             */
/*       E21780 - INCORRECT MESSAGE SENT TO MRUNQ DURING EOD -       */
/*                SHOULD SEND MSG 'RETAIL ICD BY CURRENCY LISTING'   */
/*       S01117 - MULTIBRANCHING                                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                      /*S01117*/
             PGM     PARM(&RSEQ &RLEV &RENT)                          /*S01117*/
/********    DCL     VAR(&MEM) TYPE(*CHAR) LEN(44)                 */ /*S01117*/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)                    /*S01117*/
             DCL     VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL     VAR(&RSEQ) TYPE(*CHAR) LEN(5)                    /*S01117*/
             DCL     VAR(&RLEV) TYPE(*CHAR) LEN(1)                    /*S01117*/
             DCL     VAR(&RENT) TYPE(*CHAR) LEN(3)                    /*S01117*/
/**/                                                                  /*S01117*/
/*           SNDPGMMSG MSG('REC54 - INTEREST SUB-TYPES LISTING') +      E21780*/
             SNDPGMMSG MSG('REC54 - RETAIL ICD BY CURRENCY LISTING') +
                       TOMSGQ(MRUNQ)                                  /*E21780*/
/**/
             CHGJOB SWS(00000000)
/**/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
/**/
/*********** CALL PGM(RE0540)                                         /*S01117*/
             CALL PGM(RE0540)   PARM(&RSEQ)                           /*S01117*/
/**/
             DLTOVR FILE(TABLE)
/**/
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
               IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                  SNDPGMMSG MSG('FILES OUT OF BALANCE - RE0540') TOMSGQ(MOPERQ)
               ENDDO
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)
/********       CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))        */   /*S01117*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))             /*S01117*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
