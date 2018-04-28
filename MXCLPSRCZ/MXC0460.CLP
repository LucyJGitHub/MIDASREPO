/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MX Add Export Member')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0460 - Midas MX Add Export Member                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2006           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CMX013  *CREATE    Date 29Jun06              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CMX013 - Allow additional members                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &MBR)
 
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2006')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Check if member already exists in MXPLOGPD                                 */
 
             RTVMBRD    FILE(MXPLOGPD) MBR(&MBR)
             MONMSG     MSGID(CPF9815) EXEC(DO)
 
/* Add members to physical files                                              */
 
             ADDPFM     FILE(MXMQDLPD) MBR(&MBR)
             MONMSG     MSGID(CPF5812)
             ADDPFM     FILE(MXMQDMPD) MBR(&MBR)
             MONMSG     MSGID(CPF5812)
             ADDPFM     FILE(MXMQDSPD) MBR(&MBR)
             MONMSG     MSGID(CPF5812)
             ADDPFM     FILE(MXMQDVPD) MBR(&MBR)
             MONMSG     MSGID(CPF5812)
             ADDPFM     FILE(MXMQDXPD) MBR(&MBR)
             MONMSG     MSGID(CPF5812)
 
/* Add members to logical files                                               */
 
             ADDLFM     FILE(MXMQDLL1) MBR(&MBR) DTAMBRS((MXMQDLPD +
                          (&MBR)))
             MONMSG     MSGID(CPF5812)
             ADDLFM     FILE(MXMQDML1) MBR(&MBR) DTAMBRS((MXMQDMPD +
                          (&MBR)))
             MONMSG     MSGID(CPF5812)
             ADDLFM     FILE(MXMQDSL1) MBR(&MBR) DTAMBRS((MXMQDSPD +
                          (&MBR)))
             MONMSG     MSGID(CPF5812)
             ADDLFM     FILE(MXMQDVL1) MBR(&MBR) DTAMBRS((MXMQDVPD +
                          (&MBR)))
             MONMSG     MSGID(CPF5812)
             ADDLFM     FILE(MXMQDXL1) MBR(&MBR) DTAMBRS((MXMQDXPD +
                          (&MBR)))
             MONMSG     MSGID(CPF5812)
 
/* Add members to Log files                                                   */
 
             ADDPFM     FILE(MXPLOGPD) MBR(&MBR)
             ADDLFM     FILE(MXPLOGL1) MBR(&MBR) DTAMBRS((MXPLOGPD +
                          (&MBR)))
 
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination */
 ABNOR:      DMPCLPGM
             DSPJOB     OUTPUT(*PRINT)
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd.')
 
ENDPGM
