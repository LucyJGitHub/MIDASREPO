/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD ICD mnt/enqy control - chk Witholding Tax')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC9100 - ICD display control program                       */
/*                 Check Witholding Tax                              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK024             Date 12Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      111720             Date 27Feb97              */
/*                      088074 *CREATE*    Date 16Jun95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       111720 - wrong message ID used                              */
/*       088074 - RE Witholding tax menu item appears even if MMOD   */
/*                flag is OFF.                                       */
/*                After user selects Witholding Tax Maintenance or   */
/*                Enquiry, this program checks for Witholding Tax    */
/*                being on before calling programs (now passed as    */
/*                parameters from SPF).                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROGRAM &MODULE)
 
/***COPY*SDCPYSRC,SDC9100INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC9100INT                                          */                   /*CPK024*/
 
             DCL        VAR(&PROGRAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(128)               /*E40234*/
 
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/***COPY*SDCPYSRC,SDC9100MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC9100MPS                                          */                   /*CPK024*/
 
/* Check for Witholding Tax in MMOD                 */
 
             CALL       PGM(AOMMODR0) PARM('*DBERR ' '*FIRST ' &MMOD)
 
/* Witholding Tax present                                 */
             IF         COND(%SST(&MMOD 93 1) *EQ 'Y') THEN(CALL +
                          PGM(&PROGRAM) PARM(&MODULE))
             ELSE       CMD(DO)
 
/* Witholding Tax not present                                 */
             RTVMSG     MSGID(REM0001) MSGF(GBMIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             RTVMSG     MSGID(REM0005) MSGF(GBMIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&MESSAGE)
             RTVMSG     MSGID(REM0006) MSGF(GBMIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (451 50)) VALUE(&MESSAGE)
 
             CALL       PGM(SCC0010) PARM('SDC9100' 'ENTER' &NOREPLY)
             ENDDO
 
/***COPY*SDCPYSRC,SDC9100MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC9100MPE                                          */                   /*CPK024*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/***COPY*SDCPYSRC,SDC9100ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC9100ERR                                          */                   /*CPK024*/
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - interactive job */
 
/**********  RTVMSG     MSGID(SCC0033) MSGF(GBMIDASMSG) MSG(&MESSAGE)   111720*/
             RTVMSG     MSGID(SCM0033) MSGF(GBMIDASMSG) MSG(&MESSAGE) /*111720*/
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('SDC9100' 'ENTER' &NOREPLY)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/***COPY*SDCPYSRC,SDC9100END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC9100END                                          */                   /*CPK024*/
 
/* (Add any specific end processing here) */
 
             ENDPGM
