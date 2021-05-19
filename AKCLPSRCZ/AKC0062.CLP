/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AK SE A/c key gen. - amend template keys')      */
/*********************************************************************/
/*                                                                   */
/*   Midas - Account Key Generator                                   */
/*                                                                   */
/*   AKC0062 - SE A/C Key Generation - Amend Template Keys.          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*   Last Amend No. 114468             Date 18Jan13                  */
/*   Prev Amend No. MD046248           Date 27Oct17                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  081881 *CREATE     DATE  18JAN95                 */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   114468 - Template Processing enhancement - Maintain Live Keys   */
/*            Applied for AR1079856                                  */
/*   MD046248 - Finastra Rebranding                                  */
/*   081881 - Program created (previously AKC62T).                   */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&FKEY3) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&FKEY4) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Override program file to template account keys file  */
/**********  OVRDBF     FILE(XSEACKD) TOFILE(TSEACK)               */                     /*114468*/
 
/**********  CALL       PGM(*LIBL/AK0062) PARM(&FKEY3 &FKEY4 +     */                     /*114468*/
/**********               'TEMPLATE')                              */                     /*114468*/
 
             OVRDBF     FILE(SEACKD) SHARE(*NO)                                           /*114468*/
             CALL       PGM(*LIBL/AK0062) PARM(&FKEY3 &FKEY4 +
                          'LIVEFILE')                                                     /*114468*/
             GOTO       CMDLBL(ENDPGM)
 ABNOR:
 
/*  DISPLAY MIDAS INFORMATION SCREEN                          */
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE('Securities +
                          Trading Maintain Template Keys')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE('terminated +
                          abnormally')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (451 50)) VALUE('See joblog +
                          for details')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CALL       PGM(SCC0010) PARM('AKC60T  ' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
 
ENDPGM:
             DLTOVR     FILE(XSEACKA XSEACKD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             RCLRSC
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
