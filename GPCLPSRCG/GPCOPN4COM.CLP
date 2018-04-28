/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GP Check if files to be opened for COMMIT')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GPCOPN4COM - Check if files to be opened for COMMIT         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DCOM)
 
             DCL        VAR(&DCOM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ACTIVE) TYPE(*CHAR) LEN(1)
 
             CHGVAR     VAR(&DCOM) VALUE('1')
 
/* If not already done, determine if commitment control is active */
 
             CHKOBJ     OBJ(QTEMP/GP_COMSTST) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CALL       PGM(GPCMCTACT) PARM(&ACTIVE)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/GP_COMSTST) TYPE(*CHAR) LEN(1)
             IF         COND(&ACTIVE = 'Y') THEN(DO)
             CRTDTAARA  DTAARA(QTEMP/GPDO_COM) TYPE(*CHAR) LEN(1)
             MONMSG     MSGID(CPF0000)
             ENDDO
             ENDDO
 
/* Don't do commits if commitment control is not active */
             CHKOBJ     OBJ(QTEMP/GPDO_COM) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR VAR(&DCOM) +
                          VALUE('0'))
 
             ENDPGM
