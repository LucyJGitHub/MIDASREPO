/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MQ RTALM subset extract program')               */
/********************************************************************/
/*                                                                  */
/*                  Midas Midas/Q Module                    */
/*                                                                  */
/*          MQ552XC - Asset and Liability Subset File Extract       */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 158885             Date 12Apr99             */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       158885 - Duplicate hook names in MQ552XC and MQ552X.       */
/*                Rename MQ552XC001 as MQ552XC_01                   */
/*                Rename MQ552XC002 as MQ552XC_02                   */
/*                Rename MQ552XC003 as MQ552XC_03                   */
/*                Rename MQ552XC004 as MQ552XC_04                   */
/*                                                                  */
/********************************************************************/
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)
             DCL        VAR(&EXFQ)    TYPE(*CHAR)  LEN(1)
             DCL        VAR(&NRUN)    TYPE(*CHAR)  LEN(5)
             DCL        VAR(&NNRUN)   TYPE(*DEC)   LEN(5 0)
             DCL        VAR(&RNTD)    TYPE(*CHAR)  LEN(1)
/**C*PY *N*P*S*C*MQ552XC003                           Start of 158885*/
/*/COPY WNCPYSRC,MQ552XC_03                                          */
/*                                                    End of 158885  */
             DCLF       FILE(SDBANKPD)
 
/* SEND PGM MESSAGE */
             CHGVAR     VAR(&MEM) VALUE('MQ552XC - Midas Q Asset +
                          and Liability File Extract')
/************SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)  MSGTYPE(*INFO)***/
 
/* CLEAR SWITCHES AND DATA AREA */
             CHGJOB     SWS(00000000)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             RTVDTAARA  DTAARA(MQSEL (9 1))  RTNVAR(&EXFQ)
             RTVDTAARA  DTAARA(MQSEL (12 5)) RTNVAR(&NRUN)
 
/* IF DATA HAS NOT BEEN SET UP ON DATA AREA, DO NOT RUN EXTRACT */
             IF         COND(&EXFQ *EQ ' ' *OR &NRUN *EQ '     ') +
                          THEN(GOTO CMDLBL(ENDPGM))
 
             CHGVAR     VAR(&NNRUN) VALUE(&NRUN)
             RTVDTAARA  DTAARA(MQSEL (17 1)) RTNVAR(&RNTD)
             RCVF
 
/* DETERMINE WHETHER EXTRACT PROGRAM SHOULD BE RUN TODAY         */
/* IE. IF DATE OF NEXT RUN IS LESS THAN DATE OF NEXT WORKING DAY */
/*     OR IF THE RUN TODAY FLAG IS EQUAL TO 'Y'                  */
             IF COND(&NNRUN *LT &BJDNWD *OR &RNTD *EQ 'Y') THEN(DO)
 
/* CLEAR ASSET AND LIABILITY MANAGEMENT FILE */
                 CLRPFM     FILE(MQALM)
 
/* OVERRIDE FILES*/
                 OVRDBF     FILE(CLOANX) TOFILE(CLOAN) SHARE(*NO)
                 OVRDBF     FILE(DEALSX) TOFILE(DEALS) SHARE(*NO)
                 OVRDBF     FILE(TRANS4) MBR(*ALL)
                 OVRDBF     FILE(POSTN4) MBR(*ALL)
/**C*PY *N*P*S*C*MQ552XC001                           Start of 158885*/
/*/COPY WNCPYSRC,MQ552XC_01                                          */
/*                                                    End of 158885  */
 
/* CALL ASSET AND LIABILITY FILE EXTRACT PROGRAM */
                 CALL       PGM(MQ552X)
 
/**C*PY *N*P*S*C*MQ552XC002                           Start of 158885*/
/*/COPY WNCPYSRC,MQ552XC_02                                          */
/*                                                    End of 158885  */
/* DELETE OVERRIDES */
                 DLTOVR     FILE(*ALL)
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
                 IF      COND(%SWITCH(XXXXXX11)) THEN(DO)
 
/* SET DATE LAST GENERATED TO '*ERROR*' ON DATA AREA MQSEL */
                     CHGDTAARA  DTAARA(MQSEL (18 7)) VALUE('*ERROR*')
 
                     RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                     CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                     SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) +
                               MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                 ENDDO
/**C*PY *N*P*S*C*MQ552XC004                           Start of 158885*/
/*/COPY WNCPYSRC,MQ552XC_04                                          */
/*                                                    End of 158885  */
 
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 ENDPGM:     ENDPGM
