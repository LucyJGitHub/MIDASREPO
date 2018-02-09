/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Submit pay/receive job for FT')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Funds Transfer Module                               */
/*                                                                   */
/*       FTC0804 - FT General Control component for maintenance      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CFT006             Date 06Sep99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CFT003  *CREATE    Date 06May98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CFT006 - Addition of RFT and CCT id to SDFTFRPD (recompile) */
/*       CFT003 - FT Batch Authorisation                             */
/*                Based on FTCH004A original reference DBF148        */
/*                                                                   */
/*********************************************************************/
             PGM
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCLF       FILE(SDFTFRPD)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Get FT ICD Info */
/* */
             RCVF       RCDFMT(SDFTFRD0)
/* */
/* If Automatic Pay/Receive then submit job */
/* */
             IF         COND((&BTAFTM = 'Y')) THEN(DO)
/************SBMJOB     CMD(CALL PGM(FTC0630) PARM(' ' ' ' ' ')) +                        /*CPK014*/
/************             JOB(FTC0630) JOBD(MBATCH) RTGDTA(*JOBD)                         /*CPK014*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +                           /*CPK014*/
/************             JOBD(MBATCH) RTGDTA(*JOBD) INLLIBL(*JOBD)                       /*CPK014*/
/************SBMJOB     CMD(CALL PGM(FTC0630) PARM(' ' ' ' ' ')) +                        /*CSC023*/
/************             JOB(FTC0630) JOBD(MBATCH) USER(*JOBD) +                         /*CSC023*/
/************             RTGDTA(*JOBD)                                        /*CPK014*/ /*CSC023*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +                           /*CSC023*/
/************             JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             INLLIBL(*JOBD)                                       /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(FTC0630) PARM(' ' ' ' ' ')) +
                          JOB(FTC0630) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) OUTQ(*JOBD)                                       /*CSC023*/
             SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +
                          JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD) OUTQ(*JOBD)                                      /*CSC023*/
             ENDDO
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          FTC0804 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
/* */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* */
             ENDPGM
