/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Statement Production - Drop Statement Req')  */
/*********************************************************************/
/*                                                                   */
/*       Midas    - Securities Trading Module                        */
/*                                                                   */
/*       SEC4662  - Midas SE Statement Production - Drop             */
/*                  Statement Requests.                              */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSE040  *CREATE    Date 10Apr03              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE040 - Securities Statement Processing                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,SEC4662INT                                          */
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,SEC4662MPS                                          */
 
/* Midas SE Statement Request                                        */
 
             CALL       PGM(SE4662)
 
             GOTO       CMDLBL(END)
 
ABNOR:
 
/*/COPY WNCPYSRC,SEC4662ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SEC4662 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,SEC4662END                                          */
 
             ENDPGM
