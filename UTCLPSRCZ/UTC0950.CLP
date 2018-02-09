/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Override data file utility')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UTC0950 - Override data file utility                        */
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
/*       Prev Amend No. CUP004 *CREATE     Date 27May98              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP004 - Make upgrade of DTALIB items easier                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PREFIX &LIBTYPE &FILE1 &FILE2 &PROG)
 
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBRARY) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/* Main processing */
 
             IF         COND(&LIBTYPE *EQ 'T') THEN(DO)
                 CHGVAR     VAR(&LIBRARY) VALUE(&PREFIX *CAT 'DTALIB')
             ENDDO
 
             IF         COND(&LIBTYPE *EQ 'M') THEN(DO)
                 CHGVAR     VAR(&LIBRARY) VALUE(&PREFIX *CAT 'DMLIB')
             ENDDO
 
 
             OVRDBF     FILE(&FILE1) TOFILE(&LIBRARY/&FILE1)
             OVRDBF     FILE(&FILE2) TOFILE(&LIBRARY/&FILE2)
 
             CALL       PGM(&PROG)
 
             GOTO       CMDLBL(END)
 
 ABNOR:      SNDPGMMSG  MSGID(UT00001) MSGF(*LIBL/UTMSGF) +
                          MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000)
 
             CHGJOB     SWS(XXXXXX11)
 
 END:        DLTOVR     FILE(&FILE1)
             MONMSG     MSGID(CPF0000)
 
             DLTOVR     FILE(&FILE2)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
