/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Rep last sucs. trans on primy m/c')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - System Control Module                     */
/*                                                                  */
/*       SDC1777 - Rebuild access path specified                    */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E29436             DATE  11OCT919           */
/*       PREV AMEND NO. E13205             DATE  03/04/89           */
/*                                                                  */
/********************************************************************/
/*       New program overview                                       */
/*                                                                  */
/*       E29436 - Move to SCCLSRC from RR.                          */
/*       E13205 - Rebuild path specified and send message           */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LIB &FILE &NAME)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*           Declare variables                                       */
/**/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(54)
/**/
/*           Global Monitor message                                  */
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
/**/
/*           Check object exists                                     */
/**/
             CHKOBJ     OBJ(&LIB/&FILE) OBJTYPE(*FILE) MBR(&NAME) +
                          AUT(*USE)
/**/
/*           Open and close object                                   */
/**/
             OPNDBF     FILE(&LIB/&FILE) OPTION(*INP) MBR(&NAME)
             CLOF       OPNID(&FILE)
/**/
/*           Update control file through SD1731                      */
/**/
             CALL       PGM(SD1731) PARM('*REBUILT' &FILE &LIB +
                          &NAME &RTNCDE)
/**/
/*           Send message to program                                 */
/**/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('File ' *BCAT &LIB *TCAT '/' *TCAT +
                          &FILE *BCAT &NAME *BCAT ' rebuilt') +
                          TOPGMQ(*PRV)
/**/
             GOTO END
/**/
/*           Send message to program showing error messages          */
/**/
 ABNOR:
             RCVMSG     PGMQ(*SAME) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID) MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             IF         COND(&MSGID *EQ ' ') THEN(GOTO CMDLBL(END))
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             GOTO       CMDLBL(ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
END:         ENDPGM
