/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Request Rollover Confirmations (I/C)')       */
/********************************************************************/
/*                                                                  */
/*       Midas     - Customer Lending Module                    */
/*                                                                  */
/*       LEC0425 - Request Rollover Confirmations (I/C)             */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248 *CREATE   Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. XXXXXX             Date DDMmmYY              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       XXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX            */
/*                                                                  */
/********************************************************************/
     PGM
/**                                                               **/
             DCL        VAR(&REQS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**                                                               **/
/**          CALL       PGM(LE0425) PARM(&REQS)             0085  **/
             CALL       PGM(LE0425)                       /*0085*/
/**                                                               **/
/**     IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +       0085 **/
/**                       CMDLBL(ERROR))                     0085 **/
/**                                                          0085 **/
/**          IF         COND(&REQS *EQ 'Y') +                0085 **/
/**            THEN(CHGJOB SWS(1XXXXXXX))                    0085 **/
/**            CALL      PGM(LE0426)                         0085 **/
/**                                                          0085 **/
/**                 CHGJOB SWS(0XXXXXXX)                     0085 **/
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))
ERROR:
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
               CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ)
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT)
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
