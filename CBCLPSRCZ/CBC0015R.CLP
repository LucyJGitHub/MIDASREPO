/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Call monitor menu on restart')               */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Close of Business Processing              */
/*                                                                   */
/*       CBC0015R - CALL CLOSE OF BUSINESS MONITOR MENU              */
/*                  ON RESTART OF COMPONENT                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.                    DATE 00/00/00             */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
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
/* ELSE CALL PROGRAM TO DISPLAY SCREEN */
/**/
  CALL:      CALL       PGM(CB0015) PARM('R')
/**/
/* IF PROGRAM TIMED OUT THEN SEND MESSAGE */
/* TO ALLOW USER TO RETURN TO PROGRAM */
/**/
             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
                    CHGJOB     SWS(0XXXXXXX)
                    SNDPGMMSG  MSG('CLOSE OF BUSINESS MONITOR MENU +
                                PROGRAM TIMED OUT - PRESS ENTER TO +
                                RETURN TO MENU') TOPGMQ(*EXT)
                    GOTO       CMDLBL(CALL)
             ENDDO
/**/
/* DEALLOCATE DATA AREA AND RESET TIME OUT */
/* SWITCH FOR NEXT CALL OF MONITOR */
/**/
             DLCOBJ     OBJ((CB0015 *DTAARA *EXCL))
             GOTO       CMDLBL(ENDPGM)
/**/
 ABNOR:      SNDPGMMSG  MSG('CLOSE OF BUSINESS MONITOR MENU PROGRAM +
                          TERMINATED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
ENDPGM:      ENDPGM
