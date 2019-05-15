/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Security w/ Telekur Market Price rept')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC5978 - Securities w/ Telekur Market Price Report         */
/*                          (Servitia)                               */
/*                                                                   */
/*       Function: Produce the Securities w/ Telekur Price report    */
/*                 on input cycle upon request.                      */
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
/*       Prev Amend No. S01502  *CREATE    Date 08Jul94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01502 - BLI Telekurs Processing.                           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
 
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
 
             IF         COND(%SST(&SESTAT 129 1) *EQ 'N') THEN(GOTO +
                          CMDLBL(END))
 
             CHGDTAARA  DTAARA(LDA)   VALUE(' ')
             CHGJOB SWS(00000000)
 
             CALL       PGM(SE5978)  PARM(&RSEQ)
 
/**/
/** FOR DATABASE ERRORS RECOVER DATA FROM LDA                        */
/**/
ENDTAG:      IF   COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                  CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                  SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                  TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
