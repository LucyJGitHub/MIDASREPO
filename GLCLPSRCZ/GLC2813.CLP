/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Initialisation program for fontis i/face')   */
/*********************************************************************/
/*                                                                   */
/*   Midas - Midas-Fontis Interface                                  */
/*                                                                   */
/*   GLC2813    Initialisation program for Fontis Interface          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*   Last Amend No. CPK014               Date 06Nov01                */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*   Prev Amend No. 180223               Date 13Jun00                */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  CGL004 *CREATE       Date 17APR97                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   CPK014 - Release 4 packaging.                                   */
/*            - DTAQ/GLFONTA should be cleared rather than deleted   */
/*              for authority reasons.                               */
/*   180223 - General initialisation problems.                       */
/*   CGL004 - Midas-Fontis Interface                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTNCDE &IPMODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&IPMODE) TYPE(*CHAR) LEN(1)
/*********   DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                        /*180223*/ /*CPK014*/
/*********   DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                        /*180223*/ /*CPK014*/
 
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                   /*180223*/ /*CPK014*/
/**********  CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *TCAT 'DPLIB')               /*180223*/ /*CPK014*/
/* */
/** Mode 1 - Calling program for the first time                    */
/** Mode 2 - Re-calling program if already previously used         */
/* */
 
             IF         COND((&IPMODE = '1') *OR (&IPMODE = '2')) +
                          THEN(DO)
             CHGJOB     SWS(XXXXXX00)
/************CLRPFM     FILE(GLFNARPD)                                                 */ /*180223*/
/************CPYF       FROMFILE(GLFNARPDDC) TOFILE(GLFNARPD) +                        */ /*180223*/
/************             MBROPT(*ADD)                                                 */ /*180223*/
 
/**Delete*and*re-create*data*queue*GLFONTA**/                                  /*180223*/ /*CPK014*/
/**********  DLTDTAQ    DTAQ(GLFONTA)                                          /*180223*/ /*CPK014*/
/**********  MONMSG     MSGID(CPF0000)                                         /*180223*/ /*CPK014*/
/**********  CRTDTAQ    DTAQ(&DPLIB/GLFONTA) MAXLEN(1) +                       /*180223*/ /*CPK014*/
/**********               TEXT('Midas-Fontis interface, MT940s and +           /*180223*/ /*CPK014*/
/**********               MT942s')                                             /*180223*/ /*CPK014*/
                                                                                          /*CPK014*/
/* Clear data queue GLFONTA */                                                            /*CPK014*/
                                                                                          /*CPK014*/
             CALL       PGM(QCLRDTAQ) PARM('GLFONTA' '*LIBL ')                            /*CPK014*/
                                                                                          /*180223*/
             CHGDTAARA  DTAARA(GLFONTDA (1 26)) VALUE(' ')
             CHGDTAARA  DTAARA(GLFONTDA (27 1)) VALUE('Y')
             CHGDTAARA  DTAARA(GLFONTDA (28 1)) VALUE('Y')
             CHGDTAARA  DTAARA(GLFONTDA (29 1)) VALUE('L')
             CHGDTAARA  DTAARA(GLFONTDA (30 1)) VALUE('Y')
             CHGDTAARA  DTAARA(GLFONTDA (35 12)) VALUE('MIDAS123XXXX')
             CHGDTAARA  DTAARA(GLFONTDA (47 3)) VALUE('FNS')
             CHGDTAARA  DTAARA(GLFONTDA (50 8)) VALUE('00000000')
             GOTO       CMDLBL(END)
             ENDDO
 
             IF         COND(&IPMODE = '3') THEN(DO)
             CHGJOB     SWS(XXXXXX00)
             GOTO       CMDLBL(END)
             ENDDO
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GLC2813 ended abnormally ') TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
