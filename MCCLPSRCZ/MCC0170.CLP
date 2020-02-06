/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Period File Reorg. Control')                 */
/*********************************************************************/
/*                                                                   */
/*   Midas - Management Accounts Module                      */
/*                                                                   */
/*   MCC0170 - Period File Reorganisation Control                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 10Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       228542 - RGZPFM has changed at R5V3                         */
/*                                                                   */
/*********************************************************************/
 
/*   Job switch use                                                  */
 
/*   U1 - Records have been deleted, so reorganise physical files    */
/*   U7 - Database error                                             */
/*   U8 - Database error                                             */
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50) VALUE('Error +
                          message variable')
 
/* Global error message                                              */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* Create local data area                                            */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF1023) /* LDA already exists */
 
/* Reset job switches U1, U7, U8                                     */
             CHGJOB     SWS(0XXXX000)
 
/* Call the Period File Reorganisation program                       */
             CALL       PGM(MC0170)
 
/* Check for database error                                          */
             IF         COND(%SWITCH(XXXXXX11) *OR +
                          %SWITCH(XXXXX1XX)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO      /* End of database error section */
 
/* If *INU1 is on, then records have been deleted                    */
             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
 
/* Reorganise files to remove deleted records                        */
/**********  RGZPFM     FILE(GLPERDPD) /* Period Details */                               /*228542*/
             CALL       PGM(SCC000060) PARM('GLPERDPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(GLPERSPD) /* Period Sets */                                  /*228542*/
             CALL       PGM(SCC000060) PARM('GLPERSPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
             ENDDO      /* End of records have been deleted section  */
 
             GOTO       CMDLBL(ENDPGM)
 
 ERROR:      SNDPGMMSG  MSG('Period File Reorganisation ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
ENDPGM: ENDPGM
