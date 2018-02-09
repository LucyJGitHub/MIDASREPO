/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Historical Diary Enquiry')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC7545  - Historical Diary Enquiry                         */
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
/*       Prev Amend No. CSE007             Date 01Aug97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE007 - Corporate Actions                                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
 
             CHGJOB SWS(00000000)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9800) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37)
             ENDDO
 
             CHGDTAARA  DTAARA(SESDS) VALUE(' ')
             CHGDTAARA  DTAARA(SESDS (1 8)) VALUE('SE7545')
             CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')
 
             OVRDBF FILE(SECTYX)   TOFILE(SECTY)    SHARE(*NO)
             OVRDBF FILE(SEDEVX)   TOFILE(SEDEV)    SHARE(*NO)
             OVRDBF FILE(SECTYZ1)  TOFILE(SECTY)    SHARE(*NO)
             OVRDBF FILE(SECTYZ2)  TOFILE(SECTY)    SHARE(*NO)
             OVRDBF FILE(SECTYZ3)  TOFILE(SECTY)    SHARE(*NO)
             OVRDBF FILE(TRADSX1)  TOFILE(TRADS)    SHARE(*NO)
             OVRDBF FILE(POSETDZ1)  TOFILE(POSETDY1)    SHARE(*NO)
             OVRDBF FILE(POSETDZ2)  TOFILE(POSETDY2)    SHARE(*NO)
             OVRDBF FILE(DPTMVDZ1)  TOFILE(DPTMVDY1)    SHARE(*NO)
 
             CALL       PGM(SE7545)
 
/* For Database Errors Recover Data from LDA */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                CHGVAR VAR(&MEM) VALUE('SEC7545 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             RCLRSC
 
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
