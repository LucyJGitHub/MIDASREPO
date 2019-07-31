/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE UPD.P/R INDS.&LTRIX HEADR ATEND I/C')        */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0402C - UPDATE PAY/RECEIVE INDICATORS & LTRIX HEADER    */
/*                                          AT I/C TERMINATION      */
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
/*                      S01194             Date 11Dec89              */
/*                      S01179              DATE  14/09/88          */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)         */
/*       S01179 - AS400 INCORPORATION                               */
/*       S01194 - NEW STANDING DATA                                 */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
/*           DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)             */  /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01194*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
/**/
/*   UPDATE PAY/RECEIVE INDICATORS ON CLOAN FILE                */
             SNDPGMMSG  MSG('UPDATE PAY/RECEIVE INDICATORS') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/**********  OVRDBF     FILE(TABLE) TOFILE(TABLEEE)                  * *S01194*/
             CALL       PGM(LE1080)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
                GOTO ENDPGM
             ENDDO
/**/
/************DLTOVR     FILE(*ALL)                                   * *S01194*/
/**/
             IF         COND(%SWITCH(XXXXX000)) THEN(DO)
/**/
                CLRPFM     FILE(LETX1HH)
                CLRPFM     FILE(LETX1PR)
                CLRPFM     FILE(LETX1ZZ)
                CLRPFM     FILE(LETX2HH)
                CLRPFM     FILE(LETX2PR)
                CLRPFM     FILE(LETX2ZZ)
                CLRPFM     FILE(LETX3HH)
                CLRPFM     FILE(LETX3PR)
                CLRPFM     FILE(LETX3ZZ)
                CLRPFM     FILE(LTRIEHD)
                CLRPFM     FILE(LTRIEDL)
                CLRPFM     FILE(LTRIEZZ)
                CLRPFM     FILE(LEPXTAA)
                CLRPFM     FILE(LEPXTAB)
                CLRPFM     FILE(LEPXTAC)
/**/
             ENDDO
/**/
/*   E R R O R   M E S S A G E S                                     */
/**/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
/**/
                IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                   ROLLBACK
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/*    CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))          */ /*S01194*/
      CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))             /*S01194*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ENDPGM)
                ENDDO
/**/
                IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   ROLLBACK
                   CHGVAR     VAR(&MSG) VALUE('FILE CONTROLS OUT +
                                               OF BALANCE')
                ENDDO
/**/
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
