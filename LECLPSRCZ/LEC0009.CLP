/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Lending input cycle fees init program')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Utility                                     */
/*                                                                   */
/*       LEC0009 - Lending Input Cycle Fees Initialisation Program   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Last Amend No. CLE009 *CREATE     Date 14Jun99              */
/*       Prev Amend No.                    Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE009  - LE I/C Swift Message Generation for Fees          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RETCD &MODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RETCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             IF         COND(&MODE *NE '3') THEN(CALL PGM(LE0009))
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))
 
             ELSE       CMD(DO)
               CHGVAR     VAR(&RETCD) VALUE('*ERROR*')
               CHGJOB     SWS(XXXXXX00)
             ENDDO
 
 ABNOR:      SNDPGMMSG  MSG('Program LEC0009 ended abnormally')   +
                          TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
