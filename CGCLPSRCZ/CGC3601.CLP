/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Run SQL request')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondent Module                   */
/*                                                                   */
/*       CGC3601 - Custom Defined Data Extract                       */
/*       This program allows either to check SQL statements          */
/*       or to run them                                              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CCG015  *CREATE    Date 27Jun01              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCG015 - Correspondence Manager                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTNCDE &SRCFIL &RQMBNM &SYNTAX)
 
/*/COPY WNCPYSRC,mmCnnnnINT                                          */
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYNTAX) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RQMBNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCFIL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGVAR     VAR(&RTNCDE) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Verify if Correspondence Manager SQL scripts */
/* source file is present */
             CHKOBJ     OBJ(&SRCFIL) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801 CPF9802 CPF9899) EXEC(DO)
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Run the SQL request */
             IF         COND(&SYNTAX *NE 'Y') THEN(DO)
               RUNSQLSTM  SRCFILE(&SRCFIL) SRCMBR(&RQMBNM) +
               COMMIT(*NONE)
               MONMSG     MSGID(SQL9010) EXEC(DO)
                 CHGVAR     VAR(&RTNCDE) VALUE('*SQLFAIL')
                 GOTO       CMDLBL(END)
               ENDDO
             ENDDO
             ELSE DO
               RUNSQLSTM  SRCFILE(&SRCFIL) SRCMBR(&RQMBNM) +
               COMMIT(*NONE) PROCESS(*SYN)
               MONMSG     MSGID(SQL9010) EXEC(DO)
                 CHGVAR     VAR(&RTNCDE) VALUE('*SQLFAIL')
                 GOTO       CMDLBL(END)
               ENDDO
             ENDDO
 
/*/COPY WNCPYSRC,mmCnnnnMPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,mmCnnnnERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
             CHGVAR     VAR(&RTNCDE) VALUE('*ERROR')
 
/* Abnormal termination - batch job */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC3601 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,mmCnnnnEND                                          */
 
/* (Add any specific end processing here) */
 
             ENDPGM
