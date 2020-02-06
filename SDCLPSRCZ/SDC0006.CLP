/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD CSW020 initialisation program')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Utility                                     */
/*                                                                   */
/*       SDC0006 - Standing Data CSW020 Initialisation Program       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. CSW020 *CREATE     Date 12Jan00              */
/*                                         Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSW020 - SWIFT Decimal Places                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RETCD &MODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RETCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CALL       PGM(SD0006) PARM(&MODE)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))
 
             ELSE       CMD(DO)
               CHGVAR     VAR(&RETCD) VALUE('*ERROR*')
               CHGJOB     SWS(XXXXXX00)
             ENDDO
 
 ABNOR:      SNDPGMMSG  MSG('Program SDC0006 ended abnormally')   +
                          TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
