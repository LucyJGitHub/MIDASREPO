/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Check File ACXNTAB')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0060 - Midas TI CHECK FILE                               */
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
/*       PREV AMEND     CTI002  *CREATE    Date 04JAN99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CTI002 - Midas / Trade Innovation Interface Phase 2         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FILE &RETR)
 
 
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RETR) TYPE(*CHAR) LEN(1)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&RETR) VALUE('F')
 
             CHKOBJ     OBJ(&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                        CHGVAR     VAR(&RETR) VALUE('N')
                        GOTO  END
                        ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGVAR     VAR(&RETR) VALUE('E')
             DMPCLPGM
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
