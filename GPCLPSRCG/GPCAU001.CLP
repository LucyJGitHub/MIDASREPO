/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GP Maintain Audit Files')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GPCAU001 - Maintain Audit Files                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGP004  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGP004 - Audit Reporting                                    */
/*                                                                   */
/*********************************************************************/
             PGM  PARM(&MODE)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(50)
             RTVUSRPRF  RTNUSRPRF(&USER)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* ADD PF MEMBERS FOR USER     */
/**/
             ADDPFM     FILE(GPAUFLPD) MBR(&USER)
             MONMSG     CPF0000
             ADDPFM     FILE(GPAUFDPD) MBR(&USER)
             MONMSG     CPF0000
             ADDPFM     FILE(GPAURNPD) MBR(&USER)
             MONMSG     CPF0000
             ADDPFM     FILE(GPAUASPD) MBR(&USER)
             MONMSG     CPF0000
/**/
/* ADD LF MEMBERS FOR USER     */
/**/
             ADDLFM     FILE(GPAUFLL1) MBR(&USER) DTAMBRS((GPAUFLPD +
                          (&USER)))
             MONMSG     CPF0000
             ADDLFM     FILE(GPAUFDL1) MBR(&USER) DTAMBRS((GPAUFDPD +
                          (&USER)))
             MONMSG     CPF0000
             ADDLFM     FILE(GPAUFDL2) MBR(&USER) DTAMBRS((GPAUFDPD +
                          (&USER)))
             MONMSG     CPF0000
             ADDLFM     FILE(GPAUFDL3) MBR(&USER) DTAMBRS((GPAUFDPD +
                          (&USER)))
             MONMSG     CPF0000
             ADDLFM     FILE(GPAUFDL4) MBR(&USER) DTAMBRS((GPAUFDPD +
                          (&USER)))
             MONMSG     CPF0000
             ADDLFM     FILE(GPAUFDL5) MBR(&USER) DTAMBRS((GPAUFDPD +
                          (&USER)))
             MONMSG     CPF0000
             ADDLFM     FILE(GPAUFDL6) MBR(&USER) DTAMBRS((GPAUFDPD +
                          (&USER)))
             MONMSG     CPF0000
             ADDLFM     FILE(GPAURNL1) MBR(&USER) DTAMBRS((GPAURNPD +
                          (&USER)))
             MONMSG     CPF0000
             ADDLFM     FILE(GPAUASL1) MBR(&USER) DTAMBRS((GPAUASPD +
                          (&USER)))
             MONMSG     CPF0000
/**/
/* DO OVERRIDES                */
/**/
/**/
             OVRDBF     FILE(GPAUFLPD) MBR(&USER)
             OVRDBF     FILE(GPAUFDPD) MBR(&USER)
             OVRDBF     FILE(GPAURNPD) MBR(&USER)
             OVRDBF     FILE(GPAUASPD) MBR(&USER)
 
             OVRDBF     FILE(GPAUFLL1) MBR(&USER)
             OVRDBF     FILE(GPAUFDL1) MBR(&USER)
             OVRDBF     FILE(GPAUFDL2) MBR(&USER)
             OVRDBF     FILE(GPAUFDL3) MBR(&USER)
             OVRDBF     FILE(GPAUFDL4) MBR(&USER)
             OVRDBF     FILE(GPAUFDL5) MBR(&USER)
             OVRDBF     FILE(GPAUFDL6) MBR(&USER)
             OVRDBF     FILE(GPAURNL1) MBR(&USER)
             OVRDBF     FILE(GPAUASL1) MBR(&USER)
/**/
/* CALL PROGRAM                */
/**/
             CALL       PGM(GPAU0001) PARM(&MODE)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
             GOTO END
ABNORMAL:    DMPCLPGM
             CHGVAR     VAR(&MSG) VALUE('JOB TERMINATED ABNORMALLY - +
                          REFER TO JOBLOG')
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
END:         ENDPGM
