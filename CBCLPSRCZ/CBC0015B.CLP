/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Call monitor menu from 2nd screen')          */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Close of Business Processing              */
/*                                                                   */
/*       CBC0015B - CALL CLOSE OF BUSINESS MONITOR MENU              */
/*                  FROM SECONDARY SCREEN                            */
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
/*       PREV AMEND NO.                    DATE 00/00/00             */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* ALLOCATE DATA AREA FOR EXCLUSIVE USE */
/**/
             ALCOBJ     OBJ((CB0015 *DTAARA *EXCL)) WAIT(10)
/**/
/* IF PROGRAM IS IN USE SEND MESSAGE TO SCREEN AND END PROGRAM */
/**/
             MONMSG     MSGID(CPF1002) +
                        EXEC(DO)
                                 SNDPGMMSG MSG('Menu already +
                                 displayed at another workstation') +
                                 TOPGMQ(*EXT)
                                 GOTO      CMDLBL(ENDPGM)
                        ENDDO
/**/
/* CALL PROGRAM TO DISPLAY SCREEN */
/**/
  CALL:      CALL       PGM(CB0015) PARM('B')
/**/
/* DEALLOCATE DATA AREA AND RESET TIME OUT */
/* SWITCH FOR NEXT CALL OF MONITOR */
/**/
             DLCOBJ     OBJ((CB0015 *DTAARA *EXCL))
/**/
/* RESET TIME OUT SWITCH TO ALLOW FURTHER CALL OF CB0015 */
/**/
             CHGJOB     SWS(0XXXXXXX)
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
 ABNOR:      SNDPGMMSG  MSG('CLOSE OF BUSINESS MONITOR MENU PROGRAM +
                          TERMINATED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
ENDPGM:      ENDPGM
