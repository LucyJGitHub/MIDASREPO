/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Daily teller trans files creation')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                   */
/*                                                                   */
/*       REC4203 - Daily Teller Transaction Files Creation           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG2488            Date 31May04              */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 05Sep95              */
/*                      CRT001  *CREATE    Date 28Feb95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG2488- Logical file REDDSSRCDV/TTRANL6 is based over  a   */
/*                phsical which is set to members = *nomax.  Amend   */
/*                TTRANL6 and create a  new logical file TTRANL7.    */
/*       S01408 - ADDITION OF CORE HOOK REC4203001                   */
/*       CRT001 - Retail Teller System.                              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&LDA)     TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSGDTA)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&BTIN)    TYPE(*CHAR) LEN(1)
 
             DCLF       FILE(QSYS/QAFDMBR)
/*/COPY WNCPYSRC,REC4203002                                          */
 
/**  Global Monitor Message */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
 
 
/**  Send program message */
 
             SNDPGMMSG  MSG('REC4203 - Daily teller transaction files +
                          creation') TOMSGQ(MRUNQ)
 
 
/*/COPY WNCPYSRC,REC4203003                                          */
/**  Clear FX Charge file */
 
                CLRPFM     FILE(TTCHGPD)
 
/**  Clear Narrative file */
 
                CLRPFM     FILE(TTNARPD)
 
/**  Clear Transaction files */
 
                CLRPFM     FILE(NEWTTM1)      /* NEW PF/NEWTTMx FILE */
                CLRPFM     FILE(NEWTTM2)       /* OUTPUT FROM RE4203*/
                CLRPFM     FILE(NEWTTM3)
                CLRPFM     FILE(NEWTTM4)
/*/COPY WNCPYSRC,REC4203006                                          */
                CLRPFM     FILE(CHQDPPH)
                CLRPFM     FILE(CHQDPPD)
 
 
/**  Clear individual file member of PF/TTRANPD */
 
             DSPFD      FILE(TTRANPD) TYPE(*MBR) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/TTRANMBRL)
 
             OVRDBF     FILE(QAFDMBR) TOFILE(QTEMP/TTRANMBRL)
 
 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(LOOP))
 
             CHGVAR     VAR(&BTIN) VALUE(%SST(&MBNAME 1 1))
 
             IF         COND(&BTIN *EQ 'T') THEN(DO)
             CLRPFM     FILE(TTRANPD) MBR(&MBNAME)
             MONMSG     MSGID(CPF0000)
             ENDDO
 
/*/COPY WNCPYSRC,REC4203004                                          */
             IF         COND(&BTIN *EQ 'B') THEN(DO)
             RMVM       FILE(TTRANL1) MBR(&MBNAME)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(TTRANL2) MBR(&MBNAME)
             MONMSG     MSGID(CPF0000)
             RMVM       FILE(TTRANL7) MBR(&MBNAME)                                       /*BUG2488*/
             MONMSG     MSGID(CPF0000)                                                   /*BUG2488*/
             RMVM       FILE(TTRANPD) MBR(&MBNAME)
             MONMSG     MSGID(CPF0000)
             ENDDO
 
             GOTO       CMDLBL(LOOP)
 
 
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,REC4203001                                           /*S01408*/
/**/                                                                  /*S01408*/
END: +
 
/*/COPY WNCPYSRC,REC4203005                                          */
/**  Perform file overrides */
 
                OVRDBF     FILE(TTRANPT) MBR(*ALL)
 
 
CONTINUE1:
                CHGJOB     SWS(10000000)
                CALL       PGM(RE4203)
 
 
CONTINUE2:
 
/**  Clear TTRNTMx - copy NEWTTMx to TTRNTMx */
/**  Clear NEWTTMx - reset ind */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
                   OVRDBF     FILE(NEWTTM1) SEQONLY(*YES 100)
                   OVRDBF     FILE(NEWTTM2) SEQONLY(*YES 100)
                   OVRDBF     FILE(NEWTTM3) SEQONLY(*YES 100)
                   OVRDBF     FILE(NEWTTM4) SEQONLY(*YES 100)
/*/COPY WNCPYSRC,REC4203007                                          */
                   OVRDBF     FILE(TTRNTM1) SEQONLY(*YES 100)
                   OVRDBF     FILE(TTRNTM2) SEQONLY(*YES 100)
                   OVRDBF     FILE(TTRNTM3) SEQONLY(*YES 100)
                   OVRDBF     FILE(TTRNTM4) SEQONLY(*YES 100)
/*/COPY WNCPYSRC,REC4203008                                          */
 
 
/**  Update PF/TTRNTMx */
 
                   CPYF       FROMFILE(NEWTTM1) TOFILE(TTRNTM1) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM TTRNTM1)
 
                   CPYF       FROMFILE(NEWTTM2) TOFILE(TTRNTM2) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM TTRNTM2)
 
                   CPYF       FROMFILE(NEWTTM3) TOFILE(TTRNTM3) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM TTRNTM3)
 
                   CPYF       FROMFILE(NEWTTM4) TOFILE(TTRNTM4) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM TTRNTM4)
/*/COPY WNCPYSRC,REC4203009                                          */
 
                   DLTOVR     FILE(*ALL)
 
                   CLRPFM     FILE(NEWTTM1)
                   CLRPFM     FILE(NEWTTM2)
                   CLRPFM     FILE(NEWTTM3)
                   CLRPFM     FILE(NEWTTM4)
/*/COPY WNCPYSRC,REC4203010                                          */
 
                   GOTO       CMDLBL(ENDPGM)
                ENDDO
 
 
/**  Abnormal Termination */
 
ABNORMAL:
 
/**  If U7 & U8 on - Database Error */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR    VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                          MSGDTA(&MSGDTA) TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
 
/**  End of program */
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
 
