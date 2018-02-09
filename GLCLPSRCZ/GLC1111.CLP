/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Setup Existing Amount Accruals Control')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       CL/GLC1111 - Setup Existing Amount Accruals for CGL003      */
/*                    Switchable Feature Controlling Component       */
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
/*       Prev Amend No. CGL003  *CREATE    Date 27Feb97              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL003 - Accrual Frequency on Amount Accruals               */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTNCDE &IPMODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&IPMODE) TYPE(*CHAR) LEN(1)
 
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
 
             CHGJOB     SWS(XXXXXX00)
 
/* Copy detail file for recovery */
             DLTF       FILE(QTEMP/XAMACCD)
             MONMSG     MSGID(CPF2105)
             CPYF       FROMFILE(AMACCD) TOFILE(QTEMP/XAMACCD) +
                          CRTFILE(*YES)
 
/* Setup Existing Amount Accruals for CGL003 */
             CALL       PGM(GL1111)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG  MSG('Program SEC1800 ended abnormally') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CPYF       FROMFILE(QTEMP/XAMACCD) TOFILE(*LIBL/AMACCD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             SNDPGMMSG  MSG('Error occurred in GLC1111') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
