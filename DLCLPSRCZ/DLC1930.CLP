/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL FRA/IRS Rates Maintenance Control')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - FRA/IRS Module                              */
/*                                                                   */
/*       DLC1930 - FRA/IRS RATES MAINTENANCE CONTROL                 */
/*                                                                   */
/*       Function: This Program calls DL1930 in two modes: FRA or    */
/*         (I/C)   IRS Mode - determined by Input Parameter: 'FI',   */
/*                 set in MITEM. Files are overridden as follows:    */
/*                   FRA Mode: DLFIRSRL1 => DLFRARL1                 */
/*                             DLFIRSRL2 => DLFRARL2                 */
/*                   IRS Mode: DLFIRSRL1 => DLIRSRL1                 */
/*                             DLFIRSRL2 => DLIRSRL2                 */
/*                                                                   */
/*       Calls: DL1930 - FRA/IRS Rates Maintenance.                  */
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
/*       Prev Amend No. S01328             Date 14Mar91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01328 - FRA/IRS Revaluations - New Program.                */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&FI)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&FI) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
/* Monitor for any errors and send appropriate message to external */
/* program message queue */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO ERROR)
/**/
/* If input parameter indicates FRA mode override to FRA rates files */
             IF         COND(&FI *EQ 'F') THEN(DO)
               OVRDBF     FILE(DLFIRSL1) TOFILE(DLFRARL1)
               OVRDBF     FILE(DLFIRSL2) TOFILE(DLFRARL2)
             ENDDO
/**/
/* If input parameter indicates IRS mode override to IRS rates files */
             ELSE       CMD(DO)
               OVRDBF     FILE(DLFIRSL1) TOFILE(DLIRSRL1)
               OVRDBF     FILE(DLFIRSL2) TOFILE(DLIRSRL2)
             ENDDO
/**/
/* Call FRA/IRS Maintenance program with appropriate parameter */
             CALL       PGM(DL1930) PARM(&FI)
/**/
/* Delete overrides on both files */
             DLTOVR     FILE(DLFIRSL1)
             DLTOVR     FILE(DLFIRSL2)
/**/
/* Monitor for database error and send appropriate message to MOPERQ */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ERROR)
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
ERROR:       SNDPGMMSG MSG('Transaction failed. Re-input necessary. +
                              Enter to continue.') TOPGMQ(*EXT)
             ROLLBACK
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
END:         ENDPGM
