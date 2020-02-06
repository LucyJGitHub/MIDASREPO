/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Corporate Action Default Charges Maint.')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC7519  - Corporate Action Default Charges Maintenance     */
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
/*       Prev Amend No. CSE007  *CREATE    Date 1DEc97               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE007 - Corporate Actions                                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
/* Declare variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7) VALUE('*FIRST ')
             DCL        VAR(&SAR)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR)  VALUE('CSE007')
 
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
                        SNDPGMMSG  MSG('Option not allowed.  Feature Corporate +
                          Actions not installed.') TOPGMQ(*EXT) +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
                        GOTO       CMDLBL(END)
             ENDDO
 
/* Create LDA if not present */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
               CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) AUT(*EXCLUDE)
             ENDDO
 
/* Reset external switches */
             CHGJOB     SWS(00000000)
 
/* Call program */
             CALL       PGM(SE7519)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Error processing */
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             ROLLBACK
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
