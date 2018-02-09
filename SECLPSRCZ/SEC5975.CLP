/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Extra Security Telekurs Prices Maint')       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC5975 - Extra Security Telekurs Prices Maintenance        */
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
/*       PREV AMEND NO. S01502 *CREATE     DATE 08JUL94              */
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
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)
/**/
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
/**/
             IF         COND(%SST(&SESTAT 129 1) *EQ 'N') THEN(GOTO +
                          CMDLBL(END))
/**/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(00000000)
             OVRDBF     FILE(SECTY) SHARE(*YES)
             OVRDBF     FILE(SECTR) SHARE(*YES)
             OPNQRYF    FILE((SECTY) (DPOSND)) FORMAT(SECTYD) +
                          QRYSLT('T2RF *NE "            "') +
                          KEYFLD((SESN)) JFLD((1/SESN 2/DSSC *EQ)) +
                          JDFTVAL(*ONLYDFT) MAPFLD((RECI '1/RECI')) +
                          IGNDECERR(*YES)
             OPNQRYF    FILE((SECTR) (DPOSND)) FORMAT(SECTYD) +
                          QRYSLT('T2RF *NE "            "') +
                          KEYFLD((SRPN)) JFLD((1/SESN 2/DSSC *EQ)) +
                          JDFTVAL(*ONLYDFT) MAPFLD((RECI '1/RECI')) +
                          IGNDECERR(*YES)
/**/
             CALL       PGM(SE5975)
/**/
             CLOF       OPNID(SECTR)
             CLOF       OPNID(SECTY)
             DLTOVR     FILE(SECTY SECTR)
/**/
/** Database error                                                 */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
               CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
