/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Utilities menu control program')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - UT Utilities                                        */
/*                                                                   */
/*       UTC0930 - Program Control Midas UT Utilities Menu System    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP024             Date 29Sep03              */
/* Midas Release 4.01.03 --------------------------------------------*/
/*                      CPK015             Date 27Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CUP007             Date 15May00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CUP006             Date 11Jan00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001             Date 01Mar99              */
/*                      CUP004 *CREATE     Date 08Jun98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP024 - Replace UPUICDPD with System Values.               */
/*       CPK015 - Missing override.                                  */
/*       CUP007 - Remove override to UPUICDPD if it exists.          */
/*       CUP006 - Update UTMENUPD if changed                         */
/*       CUP001 - Introduction of BRIDGE.                            */
/*       CUP004 - Make upgrade of DTALIB items easier                */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&UTPROC) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CUP006*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                                   /*CUP006*/
             DCL        VAR(&ERROR) TYPE(*DEC) LEN(1 0) VALUE(0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create Data area of menu item requested in QTEMP */
 
             CRTDTAARA  DTAARA(QTEMP/UTITEM) TYPE(*CHAR) LEN(9) +
                          VALUE('D        ') TEXT('Midas UT +
                          Utilities menu item Data Area')
             MONMSG     MSGID(CPF1023)
 
/* Reset job switches */
 
             CHGJOB     SWS(XXXXXX00)
                                                                                          /*CUP006*/
/* Reset flag for when UTMENUPD is updated                                                /*CUP006*/
                                                                                          /*CUP006*/
             CHGDTAARA DTAARA(UPSTAT (55 1)) VALUE(' ')                                   /*CUP006*/
 
/* Override message files */
 
             OVRMSGF    MSGF(SDUSRMSG) TOMSGF(GBSDUSRMSG)
             OVRMSGF    MSGF(CBUSRMSG) TOMSGF(GBCBUSRMSG)
             OVRMSGF    MSGF(MIDASMSG) TOMSGF(GBMIDASMSG)
             OVRMSGF    MSGF(Y2USRMSG) TOMSGF(GBY2USRMSG)                                 /*CPK015*/
 
/************CALL       PGM(UT0930) PARM('0001 0010 0000 0000 0000 */ /*CUP001*/
/************             0000 0000 0000 0000 0000' &ERROR)        */ /*CUP001*/
             CALL       PGM(UT0930) PARM('0001 0010 0000 0000 0000 +
                          0000 0000 0000 0000 0000 0000 0000 0000 +
                          0000 0000 0000 0000 0000 0000 0000 ' +
                          &ERROR)                                     /*CUP001*/
 
/* If UTMENUPD has been updated, copy from the temporary file in QTEMP                    /*CUP006*/
                                                                                          /*CUP006*/
             RTVDTAARA  DTAARA(UPSTAT (55 1)) RTNVAR(&UTPROC)                             /*CUP006*/
             IF         COND(&UTPROC *EQ 'Y') THEN(DO)                                    /*CUP006*/
                CPYF       FROMFILE(QTEMP/UTMENUQT) TOFILE(UTMENUPD) +
                             MBROPT(*REPLACE)                                             /*CUP006*/
                MONMSG     MSGID(CPF2817) EXEC(DO)                                        /*CUP006*/
                   CPYF       FROMFILE(@UTMENUPD) TOFILE(UTMENUPD) +
                                MBROPT(*REPLACE)                                          /*CUP006*/
                ENDDO                                                                     /*CUP006*/
                CHGDTAARA DTAARA(UPSTAT (55 1)) VALUE(' ')                                /*CUP006*/
             ENDDO                                                                        /*CUP006*/
                                                                                          /*CUP006*/
             GOTO       CMDLBL(END)
 
 ABNOR:
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('UTC0930 +
                          ended abnormally - see job log') +
                          MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             DLTOVR     FILE(SDUSRMSG)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DLTOVR     FILE(CBUSRMSG)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DLTOVR     FILE(MIDASMSG)
             MONMSG     MSGID(CPF0000 MCH0000)
                                                                                          /*CUP007*/
/**********  DLTOVR     FILE(UPUICDPD) LVL(*JOB)                            */ /*CUP007*/ /*CUP024*/
             DLTOVR     FILE(UPSVALJ0) LVL(*JOB)                                          /*CUP024*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CUP007*/
             DLTOVR     FILE(GPSVALJ0) LVL(*JOB)                                          /*CUP024*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CUP024*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
