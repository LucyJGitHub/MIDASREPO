/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('MIDAS DL Deal Sub-type/Class Changes - A/c Keys')     */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                                */
/*                                                                  */
/*       DLC0605A - DEAL SUB-TYPE/CLASS CHANGES - A/C KEYS          */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2005          */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CDL039  *CREATE    Date 22Aug05             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CDL039 - Amendable Deal Sub Types & Classes                 */
/*                                                                  */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
             SNDPGMMSG  MSG('Deal Sub-Type/Class Changes - A/c +
                          Keys') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
             CHGJOB     SWS(10000000)
 
             OVRDBF     FILE(DEALSDB) SEQONLY(*YES 500) OVRSCOPE(*JOB)
             OVRDBF     FILE(DEALSDC) SEQONLY(*YES 500) OVRSCOPE(*JOB)
             OVRDBF     FILE(DEALSDD) SEQONLY(*YES 500) OVRSCOPE(*JOB)
             OVRDBF     FILE(DEALSDE) SEQONLY(*YES 500) OVRSCOPE(*JOB)
             OVRDBF     FILE(DEALSDG) SEQONLY(*YES 500) OVRSCOPE(*JOB)
 
             CLRPFM     FILE(DLSTCLPD) MBR(NEW)
             OVRDBF     FILE(DLSTCLPD) TOFILE(DLSTCLPD) MBR(NEW) SEQONLY(*YES 500) OVRSCOPE(*JOB)
 
             CLRPFM     FILE(DLDKEYPD)
             OVRDBF     FILE(DLDKEYPD) TOFILE(DLDKEYPD) SEQONLY(*YES 500) OVRSCOPE(*JOB)
 
             CALL       PGM(DLSTCLCG) PARM(' ')
             DLTOVR     FILE(DLSTCLPD) LVL(*JOB)
 
/*   ERROR MESSAGES                                          */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                SNDPGMMSG  MSG('JOB TERMINATED-DATABASE IN ERROR') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
 
             CPYF       FROMFILE(DLSTCLPD) TOFILE(DLSTCLPD) +
                          FROMMBR(NEW) TOMBR(DLSTCLPD) MBROPT(*REPLACE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DLSTCLPD)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd.')
             ENDPGM
